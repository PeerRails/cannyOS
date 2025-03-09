#!/usr/bin/env just --justfile

_default:
  just --list -u

# Clean up old up unused docker images, volumes
clean-docker:
    #!/usr/bin/bash
    docker image prune -af
    docker volume prune -f

dockerNameFormat := `docker container ls --format "{{.Names}}"`
# List running docker containers
dockerlist:
    #!/bin/bash
    for i in {{dockerNameFormat}};
    do
            printf "\e[1;32m\n%s\e[0m\n%s\n" "$i";
    done

# get logs for this boot and last boot, cleanly output in terminal as pastebin links, to simplify troubleshooting and issue reporting.
get-logs:
    #!/bin/bash
    # Get logs for this boot
    this_boot_logs=$(journalctl -b)
    echo -e "${bold}Logs This Boot:${normal} $this_boot_logs"
    echo " "
    # Get logs for last boot
    last_boot_logs=$(journalctl -b -1)
    echo -e "${bold}Logs Last Boot:${normal} $last_boot_logs"
    echo " "

# Kills all processes related to wine and proton. This forces it to restart next time you launch the game (you might still have to press STOP in steam to kill the game binary)
fix-proton-hang:
    #!/usr/bin/bash
    PROTONCORE=(pv-bwrap pressure-vessel reaper explorer.exe rpcss.exe plugplay.exe services.exe svchost.exe winedevice.exe winedevice.exe wineserver)
    for PROG in "${PROTONCORE[@]}"; do
      killall -9 "$PROG"
    done

# Install OpenTabletDriver, an open source, cross-platform, user-mode tablet driver
install-opentabletdriver:
    #!/usr/bin/bash
    echo "Installing OpenTabletDriver..."
    curl -s https://api.github.com/repos/OpenTabletDriver/OpenTabletDriver/releases/latest \
    | jq -r '.assets | sort_by(.created_at) | .[] | select (.name|test("opentabletdriver.*tar.gz$")) | .browser_download_url' \
    | wget -qi - -O /tmp/OpenTabletDriver/opentabletdriver.tar.gz && \
    tar --strip-components=1 -xvzf /tmp/OpenTabletDriver/opentabletdriver.tar.gz -C /tmp/OpenTabletDriver && \
    sudo cp /tmp/OpenTabletDriver/etc/udev/rules.d/70-opentabletdriver.rules /etc/udev/rules.d/71-opentabletdriver.rules && \
    rm -rf /tmp/OpenTabletDriver && \
    mkdir -p $HOME/.config/OpenTabletDriver && \
    mkdir -p $HOME/.config/systemd/user && \
    curl -s https://raw.githubusercontent.com/flathub/net.opentabletdriver.OpenTabletDriver/refs/heads/master/scripts/opentabletdriver.service > $HOME/.config/systemd/user/opentabletdriver.service  && \
    systemctl --user daemon-reload && \
    systemctl enable --user --now opentabletdriver.service

# Setup WACOM
wacom:
    #!/usr/bin/bash
    xsetwacom --set "HUION Huion Tablet Pad pad" Button 12 "key +ctrl +z -ctrl"
    xsetwacom --set "HUION Huion Tablet Pad pad" Button 11 "key +ctrl"

# Remove OpenTabletDriver
remove-opentabletdriver:
    #!/usr/bin/bash
    echo "Uninstalling OpenTabletDriver..."
    sudo -A rm /etc/udev/rules.d/71-opentabletdriver.rules && \
    systemctl disable --user --now opentabletdriver.service

# Convert nosound, put video and output
convert_nosound video output:
  ffmpeg -i "{{video}}" -max_muxing_queue_size 9999 -vcodec libx264 -crf 29 -maxrate 4.5M -flags +global_header -pix_fmt yuv420p -movflags +faststart -an "{{output}}"

# Convert video with sound, put video and output
convert_sound video output:
  ffmpeg -i "{{video}}" -max_muxing_queue_size 9999 -vcodec libx264 -crf 29 -maxrate 4.5M -flags +global_header -pix_fmt yuv420p -movflags +faststart -c:a aac -ac 2 "{{output}}"

# Merge soundpost, put video, sound and output
merge_soundpost video sound output:
  ffmpeg -stream_loop -1 -i "{{video}}" -i "{{sound}}" -shortest -map 0:v:0 -map 1:a:0 -y -max_muxing_queue_size 9999 -vcodec libx264 -crf 29 -maxrate 4.5M -flags +global_header -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -movflags +faststart -c:a aac -ac 2 "{{output}}"

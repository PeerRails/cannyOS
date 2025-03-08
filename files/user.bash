# ./bashrc.d/10-user

HISTSIZE=5000
HISTFILESIZE=5000

C_RED="\[\e[0;31m\]"
C_YELLOW="\[\e[0;33m\]"
C_CYAN="\[\e[0;36m\]"
C_RESET="\[\e[m\]"
USER_SYMBOL="${C_RED}\u${C_RESET}"
HOST_SYMBOL="${C_CYAN}\h${C_RESET}"
PATH_SYMBOL="${C_YELLOW}\w${C_RESET}"
pyenv() {
  local py=$([[ "$VIRTUAL_ENV" == "" ]]; echo $?)
  if [ $py -eq 1 ]; then
    echo -n "(${C_CYAN}$(basename $(echo ${VIRTUAL_ENV}))${C_RESET}) "
  fi
}
PS1="${USER_SYMBOL}\
@${HOST_SYMBOL} \
${PATH_SYMBOL} $(pyenv)\

$ "

# Aliases
alias ll="ls -lh"
alias lt="ls --human-readable --size -1 -S --classify"
alias gh="history | grep"
alias count="find . -type f | wc -l"
alias doomradio="mpv --no-resume-playback https://www.youtube.com/watch?v=JEuAYnjtJP0"
# alias tf="terraform"
# alias bindle="bundle install --path vendor"
# source <(oc completion bash)
# source <(kubectl completion bash)
export EDITOR=vim
alias k="kubectl"
alias yt="youtube-dl"
alias psmem="ps -eo pmem,pcpu,vsize,pid,cmd | sort -k 1 -nr | head -5"
# alias tor-browser="firejail /reimu/tor/tor-browser_en-US/Browser/start-tor-browser"
# alias restartkde="kquitapp5 plasmashell && plasmashell &"
alias plist="ps -Hefcwww"
alias activenet='netstat -tulpn | grep LISTEN'

dockerplist() {
for i in $(docker container ls --format "{{.Names}}");
do
        printf "\e[1;32m\n%s\e[0m\n%s\n" "$i";
done
}

# Tablet
#xsetwacom --set "HUION Huion Tablet Pad pad" Button 12 "key +ctrl +z -ctrl"
#xsetwacom --set "HUION Huion Tablet Pad pad" Button 11 "key +ctrl"

# Dotnet Telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Random
alias random-string="openssl rand -base64 24"
alias keyring-rm="rm -rf .local/share/keyrings/"

# Kill krunner
alias killkrunner="ps aux | grep krunner | grep -v grep | awk '{print \"kill -9 \" $2}' | bash"

# Protontricks
# alias protontricks="flatpak run com.github.Matoking.protontricks"

# RDP
# alias grpd="flatpak run com.freerdp.FreeRDP /u:user /size:2440x1280 /v:192.168.122.18 /sound "

# Soft-Server
# alias gitgovnohelp="echo 'https://github.com/charmbracelet/soft-serve'"
# alias gitgovno="ssh -i ~/.ssh/id_rsa git.fed001.lan -p 23333"

# Plasma Renderer Error
alias qtquick="kcmshell6 qtquicksettings"

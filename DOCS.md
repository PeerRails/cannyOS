### ZSH

```zsh
# Upgrade
alias y="yay"

# Search
alias ys="yay -Ss"

# Install
alias yi="yay -S"

# Remove
alias yr="yay -R"
```

### Mitigations

- Отключить Split Lock Mitigation
  ```bash
  echo "kernel.split_lock_mitigate=0" >> /etc/sysctl.d/99-splitlock.conf
  kernelstub -a split_lock_detect=off
  kernelstub -p
  ```

### Подготовка
- Установить ОС
- Установить игровые пакеты
- Открыть ssh
- Настроить башрц
- Мигрировать $HOME/.ssh
- Мигрировать профиль firefox
- Мигрировать профиль Thunderbird
- Перенести .vimrc

### Пакеты
- Весь список в [vars.yaml](vars.yaml)

### Проблемы

???

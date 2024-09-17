cat >> Brewfile <<EOF
tap "blacktop/tap"
tap "homebrew/bundle"
brew "jq"
brew "blacktop/tap/ipsw"
brew "radare2"
brew "yara"
brew "ripgrep"
brew "exiftool"
brew "cmake"
cask "wireshark"
cask "idafree"
cask "jtool2"
cask "red-canary-mac-monitor"
cask "visual-studio-code"
cask "suspicious-package"
cask "processmonitor"
cask "filemonitor"
cask "netiquette"
cask "taskexplorer"
cask "whatsyoursign"
cask "dnsmonitor"
cask "lulu"
cask "hex-fiend"
cask "machoview"
cask "pacifist"
cask "script-debugger"
cask "proxyman"
cask "bbedit"
cask "procexp"
cask "filemon"
cask "hfsleuth"
cask "simplistic"
EOF

brew bundle --file=Brewfile || true
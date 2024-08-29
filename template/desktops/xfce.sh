#!/bin/bash

# Remove any preconfigured monitors
if [[ -f "${HOME}/.config/monitors.xml" ]]; then
  mv "${HOME}/.config/monitors.xml" "${HOME}/.config/monitors.xml.bak"
fi
echo "TIMING: $(date -Iseconds) - removed any preconfigured monitors"

# Copy over default panel if doesn't exist, otherwise it will prompt the user
PANEL_CONFIG="${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
if [[ ! -e "${PANEL_CONFIG}" ]]; then
  mkdir -p "$(dirname "${PANEL_CONFIG}")"
  cp "/etc/xdg/xfce4/panel/default.xml" "${PANEL_CONFIG}"
fi
echo "TIMING: $(date -Iseconds) - Copied default panel config"

# Disable startup services
xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -n -t bool -s false
xfconf-query -c xfce4-session -p /startup/gpg-agent/enabled -n -t bool -s false
echo "TIMING: $(date -Iseconds) - Disabled startup services"

# Turn off power saving measures that turn off the display
xfconf-query \
    --channel xfce4-power-manager \
    --property /xfce4-power-manager/dpms-enabled \
    --create \
    --type bool \
    --set true

xfconf-query \
    --channel xfce4-power-manager \
    --property /xfce4-power-manager/dpms-on-ac-off \
    --create \
    --set 0 \
    --type uint

xfconf-query \
    --channel xfce4-power-manager \
    --property /xfce4-power-manager/dpms-on-ac-sleep \
    --create \
    --set 0 \
    --type uint

xfconf-query \
    --channel xfce4-power-manager \
    --property /xfce4-power-manager/blank-on-ac \
    --create \
    --set 0 \
    --type int

# Show the power management settings in output
echo "xfconf-query settings for xfce-power-manager:"
xfconf-query --channel xfce4-power-manager --list --verbose

# Disable useless services on autostart
AUTOSTART="${HOME}/.config/autostart"
rm -fr "${AUTOSTART}"    # clean up previous autostarts
mkdir -p "${AUTOSTART}"
for service in "pulseaudio" "rhsm-icon" "spice-vdagent" "tracker-extract" "tracker-miner-apps" "tracker-miner-user-guides" "xfce4-power-manager" "xfce-polkit"; do
  echo -e "[Desktop Entry]\nHidden=true" > "${AUTOSTART}/${service}.desktop"
done
echo "TIMING: $(date -Iseconds) - Disabled useless services"

# Run Xfce4 Terminal as login shell (sets proper TERM)
TERM_CONFIG="${HOME}/.config/xfce4/terminal/terminalrc"
if [[ ! -e "${TERM_CONFIG}" ]]; then
  mkdir -p "$(dirname "${TERM_CONFIG}")"
  sed 's/^ \{4\}//' > "${TERM_CONFIG}" << EOL
    [Configuration]
    CommandLoginShell=TRUE
EOL
else
  sed -i \
    '/^CommandLoginShell=/{h;s/=.*/=TRUE/};${x;/^$/{s//CommandLoginShell=TRUE/;H};x}' \
    "${TERM_CONFIG}"
fi

echo "TIMING: $(date -Iseconds) - Setup complete, starting xfce session"
# Start up xfce desktop (block until user logs out of desktop)
xfce4-session

#!/bin/bash
# ==============================================================================
# Script: set_proxy.sh
# Description: Helper script to set or unset proxy for Shell, Apt, Git, Curl,
#              Wget, NPM, Yarn, and Docker.
#
# Usage:
#   1. Set Proxy:
#      ./set_proxy.sh http://proxy.company.com:8080
#      ./set_proxy.sh http://proxy.company.com:8080 "localhost,127.0.0.1,10.0.0.0/8"
#      OR
#      PROXY="http://proxy.company.com:8080" NO_PROXY="localhost,127.0.0.1" ./set_proxy.sh
#
#   2. Unset / Clear Proxy:
#      ./set_proxy.sh unset
#      OR
#      ./set_proxy.sh off
# ==============================================================================

set -e

PROXY_URL="${1:-${CUSTOM_PROXY:-${PROXY:-${HTTP_PROXY:-${http_proxy:-""}}}}}"
NO_PROXY_VAL="${2:-${CUSTOM_NO_PROXY:-${NO_PROXY:-${no_proxy:-"localhost,127.0.0.1,.local"}}}}}"

# Detect real user home directory (works even when script is invoked via sudo)
REAL_USER="${SUDO_USER:-$USER}"
HOME_DIR="$(eval echo "~$REAL_USER")"

# Determine Action: set or unset
if [[ "$PROXY_URL" == "unset" || "$PROXY_URL" == "off" || "$PROXY_URL" == "clear" ]]; then
    ACTION="unset"
    PROXY_URL=""
elif [ -n "$PROXY_URL" ]; then
    ACTION="set"
else
    ACTION="unset"
fi

echo "=================================================="
if [ "$ACTION" == "set" ]; then
    echo " Setting Proxy: $PROXY_URL"
    echo " No Proxy: $NO_PROXY_VAL"
else
    echo " Unsetting / Clearing all Proxy configurations"
fi
echo " Target Home: $HOME_DIR"
echo "=================================================="

# 1. Configure Shell (.bashrc & .zshrc)
set_proxy_shell() {
    local target_files=()
    [ -f "$HOME_DIR/.bashrc" ] && target_files+=("$HOME_DIR/.bashrc")
    [ -f "$HOME_DIR/.zshrc" ] && target_files+=("$HOME_DIR/.zshrc")

    for file in "${target_files[@]}"; do
        # Clean up existing managed proxy block & legacy un-blocked proxy lines
        sed -i '/# BEGIN PROXY CONFIG/,/# END PROXY CONFIG/d' "$file"
        sed -i '/export http_proxy=/d; /export https_proxy=/d; /export no_proxy=/d; /export HTTP_PROXY=/d; /export HTTPS_PROXY=/d; /export NO_PROXY=/d' "$file"

        if [ "$ACTION" == "set" ]; then
            cat <<EOF >> "$file"
# BEGIN PROXY CONFIG
export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"
export no_proxy="$NO_PROXY_VAL"
export HTTP_PROXY="$PROXY_URL"
export HTTPS_PROXY="$PROXY_URL"
export NO_PROXY="$NO_PROXY_VAL"
# END PROXY CONFIG
EOF
        fi
        echo "  [Shell] Updated $(basename "$file")"
    done
}

# 2. Configure Git
set_proxy_git() {
    if command -v git &>/dev/null; then
        if [ "$ACTION" == "set" ]; then
            git config --global http.proxy "$PROXY_URL"
            git config --global https.proxy "$PROXY_URL"
            echo "  [Git] Proxy configured: $PROXY_URL"
        else
            git config --global --unset http.proxy 2>/dev/null || true
            git config --global --unset https.proxy 2>/dev/null || true
            echo "  [Git] Proxy unset"
        fi
    fi
}

# 3. Configure Apt
set_proxy_apt() {
    local apt_conf="/etc/apt/apt.conf.d/http-proxy.conf"
    if [ "$ACTION" == "set" ]; then
        sudo mkdir -p /etc/apt/apt.conf.d
        sudo tee "$apt_conf" >/dev/null <<EOF
Acquire::http::Proxy "$PROXY_URL";
Acquire::https::Proxy "$PROXY_URL";
EOF
        echo "  [APT] Proxy configured in $apt_conf"
    else
        [ -f "$apt_conf" ] && sudo rm -f "$apt_conf"
        echo "  [APT] Proxy removed from $apt_conf"
    fi
}

# 4. Configure Curl
set_proxy_curl() {
    for h in "$HOME_DIR" "/root"; do
        local curlrc="$h/.curlrc"
        if [ "$ACTION" == "set" ]; then
            if [ "$h" == "/root" ]; then
                sudo tee "$curlrc" >/dev/null <<< "proxy=\"$PROXY_URL\""
            else
                echo "proxy=\"$PROXY_URL\"" > "$curlrc"
            fi
        else
            if [ "$h" == "/root" ]; then
                [ -f "$curlrc" ] && sudo rm -f "$curlrc"
            else
                [ -f "$curlrc" ] && rm -f "$curlrc"
            fi
        fi
    done
    echo "  [Curl] Proxy $ACTION completed"
}

# 5. Configure Wget
set_proxy_wget() {
    for h in "$HOME_DIR" "/root"; do
        local wgetrc="$h/.wgetrc"
        if [ "$ACTION" == "set" ]; then
            local content="http_proxy = $PROXY_URL
https_proxy = $PROXY_URL
ftp_proxy = $PROXY_URL
no_proxy = $NO_PROXY_VAL"
            if [ "$h" == "/root" ]; then
                sudo tee "$wgetrc" >/dev/null <<< "$content"
            else
                echo "$content" > "$wgetrc"
            fi
        else
            if [ "$h" == "/root" ]; then
                [ -f "$wgetrc" ] && sudo rm -f "$wgetrc"
            else
                [ -f "$wgetrc" ] && rm -f "$wgetrc"
            fi
        fi
    done
    echo "  [Wget] Proxy $ACTION completed"
}

# 6. Configure NPM & Yarn
set_proxy_npm_yarn() {
    if [ "$ACTION" == "set" ]; then
        cat <<EOF > "$HOME_DIR/.npmrc"
http-proxy="$PROXY_URL"
https-proxy="$PROXY_URL"
proxy="$PROXY_URL"
strict-ssl=false
EOF
        cat <<EOF > "$HOME_DIR/.yarnrc"
http-proxy "$PROXY_URL"
https-proxy "$PROXY_URL"
proxy "$PROXY_URL"
strict-ssl false
EOF
        echo "  [NPM/Yarn] Proxy configured"
    else
        [ -f "$HOME_DIR/.npmrc" ] && rm -f "$HOME_DIR/.npmrc"
        [ -f "$HOME_DIR/.yarnrc" ] && rm -f "$HOME_DIR/.yarnrc"
        echo "  [NPM/Yarn] Proxy removed"
    fi
}

# 7. Configure Docker
set_proxy_docker() {
    local docker_conf_dir="/etc/systemd/system/docker.service.d"
    local docker_conf="$docker_conf_dir/http-proxy.conf"

    if [ "$ACTION" == "set" ]; then
        sudo mkdir -p "$docker_conf_dir"
        sudo tee "$docker_conf" >/dev/null <<EOF
[Service]
Environment="HTTP_PROXY=$PROXY_URL"
Environment="HTTPS_PROXY=$PROXY_URL"
Environment="NO_PROXY=$NO_PROXY_VAL"
EOF
        echo "  [Docker] Systemd override created at $docker_conf"
    else
        [ -f "$docker_conf" ] && sudo rm -f "$docker_conf"
        echo "  [Docker] Systemd override removed"
    fi

    if command -v systemctl &>/dev/null && systemctl is-active --quiet docker 2>/dev/null; then
        sudo systemctl daemon-reload
        sudo systemctl restart docker || true
        echo "  [Docker] Service reloaded"
    fi
}

# Execute all functions
set_proxy_shell
set_proxy_git
set_proxy_apt
set_proxy_curl
set_proxy_wget
set_proxy_npm_yarn
set_proxy_docker

echo "=================================================="
echo " Proxy configuration $ACTION finished!"
echo " Note: Restart your shell or run 'source ~/.bashrc' / 'source ~/.zshrc'"
echo "=================================================="

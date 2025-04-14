#!/usr/bin/env zsh

DEFAULT_HOME_PATH="$HOME"
DEFAULT_NO_PROXY="localhost,127.0.0.1,::1"


if [[ "$PROXY" ]]; then
    # if PROXY argument is provided
    proxy="$PROXY"
else
    echo "Proxy is required. Usage: PROXY=<proxy_url> NO_PROXY=<no_proxy_url> HOME_PATH=<home_path> zsh set_proxy.sh"
    exit 1
fi

# Validate proxy format
if [[ ! "$proxy" =~ ^http(s)?:// ]]; then
    echo "Error: Proxy format must be http:// or https://"
    exit 1
fi

if [[ "$NO_PROXY" ]]; then
    # if NO_PROXY argument is provided
    no_proxy="$NO_PROXY"
else
    no_proxy="$DEFAULT_NO_PROXY"
fi


if [ "$HOME_PATH" ]; then
    # if HOME_PATH argument is provided
    home_path="$HOME_PATH"
else
    home_path="$DEFAULT_HOME_PATH"
fi

set_proxy_docker() {
  # Create or update the Docker systemd service override file
  FILE_PATH="/etc/systemd/system/docker.service.d"

  # Create the directory if it doesn't exist
  mkdir -p $FILE_PATH
  SERVICE_FILE="$FILE_PATH/http-proxy.conf"

  # Write the proxy configuration to the file
  sudo tee "$SERVICE_FILE" <<EOF > /dev/null
[Service]
Environment="HTTP_PROXY=$proxy"
Environment="HTTPS_PROXY=$proxy"
Environment="NO_PROXY=$no_proxy"
EOF
  # Reload the systemd daemon to apply the changes
  systemctl daemon-reload

  # Restart the Docker service
  systemctl restart docker

  echo "Docker proxy set to: $proxy"
}

set_proxy_apt() {
  # Create or update the APT systemd service override file
  FILE_PATH="/etc/apt/apt.conf.d"
  SERVICE_FILE="$FILE_PATH/http-proxy.conf"

  # Write the proxy configuration to the file
  sudo tee "$SERVICE_FILE" <<EOF > /dev/null
Acquire::http::Proxy "$proxy";
Acquire::https::Proxy "$proxy";
EOF

  echo "APT proxy set to: $proxy"
}



set_proxy_git() {
  # Create or update the APT systemd service override file
  FILE_PATH="$home_path"
  SERVICE_FILE="$FILE_PATH/.gitconfig"
  # Write the proxy configuration to the file
  cat <<EOF > "$SERVICE_FILE"
[credential]
      helper = store
[http "https://github.com"]
	proxy = $proxy 
	sslVerify = false
[https "https://github.com"]
	proxy = $proxy 
	sslVerify = false
EOF
  echo "Github proxy set to: $proxy"
}


set_proxy_yarn() {
  FILE_PATH="$home_path"
  SERVICE_FILE="$FILE_PATH/.yarnrc"

  # Write the proxy configuration to the file
  cat <<EOF > "$SERVICE_FILE"
http-proxy "$proxy"
https-proxy "$proxy"
proxy "$proxy"
strict-ssl false
EOF

  echo "Yarn proxy set to: $proxy"
}



set_proxy_npm() {
  FILE_PATH="$home_path"
  SERVICE_FILE="$FILE_PATH/.npmrc"
  # Write the proxy configuration to the file
  cat <<EOF > "$SERVICE_FILE"
http-proxy="$proxy"
https-proxy="$proxy"
proxy="$proxy"
strict-ssl=false
EOF
  echo "Npm proxy set to: $proxy"
}



set_proxy_shell() {
  FILE_PATH="$home_path"
  SERVICE_FILE="$FILE_PATH/.$(basename "$SHELL")rc"
  # Write the proxy configuration to the file
  cat <<EOF >> "$SERVICE_FILE"
export http_proxy="$proxy"
export https_proxy="$proxy"
export no_proxy="$no_proxy"
export HTTP_PROXY="$proxy"
export HTTPS_PROXY="$proxy"
export NO_PROXY="$no_proxy"
EOF
  echo "Shell proxy set to: $proxy"
}


set_proxy_git
set_proxy_docker
set_proxy_apt
set_proxy_yarn
set_proxy_npm
set_proxy_shell
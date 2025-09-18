#!/bin/bash

DEFAULT_PROXY=""
DEFAULT_NO_PROXY="localhost,127.0.0.1"
DEFAULT_HOME_PATH="/home/vbox"

# Check if CUSTOM_PROXY argument is provided
if [[ "$CUSTOM_PROXY" ]]; then
    echo "Set proxy to the custom $CUSTOM_PROXY"
    _proxy="$CUSTOM_PROXY"
else
    echo "Set proxy to the default one $DEFAULT_PROXY"
    _proxy="$DEFAULT_PROXY"
fi



# Check if CUSTOM_NO_PROXY argument is provided
if [[ "$CUSTOM_NO_PROXY" ]]; then
    echo "Set no_proxy to the custom $CUSTOM_NO_PROXY"
    _no_proxy="$CUSTOM_NO_PROXY"
else
    echo "Set no_proxy to the default one $DEFAULT_NO_PROXY"
    _no_proxy="$DEFAULT_NO_PROXY"
fi

# Check if CUSTOM_HOME_PATH argument is provided
if [[ "$CUSTOM_HOME_PATH" ]]; then
    echo "Set home_path to the custom $CUSTOM_HOME_PATH"
    _home_path="$CUSTOM_HOME_PATH"
else
    echo "Set home_path to the default one $DEFAULT_HOME_PATH"
    _home_path="$DEFAULT_HOME_PATH"
fi

current_shell=$(basename "$SHELL")

if [[ "$current_shell" == "bash" ]]; then 
    _shell_config_path="$_home_path/.bashrc"
elif [[ "$current_shell" == "zsh" ]]; then
    _shell_config_path="$_home_path/.zshrc"
else
    echo "Not supported shell $current_shell"
    return
fi


echo "shell config path $_shell_config_path"

set_proxy_docker() {
  # Create or update the Docker systemd service override file
  FILE_PATH="/etc/systemd/system/docker.service.d"
  # Create the directory if it doesn't exist
  mkdir -p $FILE_PATH
  SERVICE_FILE="$FILE_PATH/http-proxy.conf"

  # Write the proxy configuration to the file
  cat <<EOF > "$SERVICE_FILE"
[Service]
Environment="HTTP_PROXY=$_proxy"
Environment="HTTPS_PROXY=$_proxy"
Environment="NO_PROXY=$_no_proxy"
EOF

  # Reload the systemd daemon to apply the changes
  systemctl daemon-reload

  # Restart the Docker service
  systemctl restart docker
  echo "Docker proxy set to: $_proxy"
}

set_proxy_apt() {
  # Create or update the APT systemd service override file
  FILE_PATH="/etc/apt/apt.conf.d"
  SERVICE_FILE="$FILE_PATH/http-proxy.conf"
  # Write the proxy configuration to the file
  cat <<EOF > "$SERVICE_FILE"
Acquire::http::Proxy "$_proxy";
Acquire::https::Proxy "$_proxy";
EOF

  echo "APT proxy set to: $_proxy"
}





set_proxy_git() {
  # Create or update the APT systemd service override file
  FILE_PATH="$_home_path"
  SERVICE_FILE="$FILE_PATH/.gitconfig"
  # Write the proxy configuration to the file
  cat <<EOF > "$SERVICE_FILE"
[credential]
      helper = store
[http "https://github.com"]
	proxy = $_proxy 
	sslVerify = false

[https "https://github.com"]
	proxy = $_proxy 
	sslVerify = false
EOF

  echo "Github proxy set to: $_proxy"
}

set_proxy_yarn() {
  FILE_PATH="$_home_path"
  SERVICE_FILE="$FILE_PATH/.yarnrc"

  # Write the proxy configuration to the file
  cat <<EOF > "$SERVICE_FILE"
http-proxy "$_proxy"
https-proxy "$_proxy"
proxy "$_proxy"

strict-ssl false
EOF

  echo "Yarn proxy set to: $_proxy"
}

set_proxy_npm() {
  FILE_PATH="$_home_path"
  SERVICE_FILE="$FILE_PATH/.npmrc"

  # Write the proxy configuration to the file
  cat <<EOF > "$SERVICE_FILE"
http-proxy="$_proxy"
https-proxy="$_proxy"
proxy="$_proxy"
strict-ssl=false
EOF

  echo "Npm proxy set to: $_proxy"
}


set_proxy_shell() {
  # Write the proxy configuration to the file
  cat <<EOF >> "$_shell_config_path"
export http_proxy="$_proxy"
export https_proxy="$_proxy"
export no_proxy="$_no_proxy"

export HTTP_PROXY="$_proxy"
export HTTPS_PROXY="$_proxy"
export NO_PROXY="$_no_proxy"
EOF

  echo "Shell proxy set to: $_proxy"
}


set_proxy_curl() {
  sudo tee $_home_path/.curlrc << EOF
proxy="$_proxy"
EOF
  sudo tee /root/.curlrc << EOF
proxy="$_proxy"
EOF
  echo "Set proxy for curl to: $_proxy"
}

set_proxy_wget() {
  sudo tee $_home_path/.wgetrc << EOF
http_proxy = $_proxy
https_proxy = $_proxy
ftp_proxy = $_proxy
no_proxy = $_no_proxy
EOF

  sudo tee /root/.wgetrc << EOF
http_proxy = $_proxy
https_proxy = $_proxy
ftp_proxy = $_proxy
no_proxy = $_no_proxy
EOF

  echo "Set proxy for wget to: $_proxy"
}

set_proxy_git
set_proxy_docker
set_proxy_apt
set_proxy_yarn
set_proxy_npm
set_proxy_shell
set_proxy_curl
set_proxy_wget

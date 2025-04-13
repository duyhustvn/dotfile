#!/usr/bin/env zsh

install_go_tool() {
  # gopls
  go install golang.org/x/tools/gopls@latest

  # REPL!
  go install github.com/x-motemen/gore/cmd/gore@latest

  # Autocompletion
  go install github.com/stamblerre/gocode@latest

  # Documentation
  go install golang.org/x/tools/cmd/godoc@latest

  # Add/Removed Necessary Imports
  go install golang.org/x/tools/cmd/goimports@latest

  # Type-Safe Renaming of Go identifiers
  go install golang.org/x/tools/cmd/gorename@latest

  # Asks questions about your Gocode
  go install golang.org/x/tools/cmd/guru@latest

  # Generate tests based off of the func you're on
  go install github.com/cweill/gotests/gotests@latest

  # Add `json` or `bson` to structs easily
  go install github.com/fatih/gomodifytags@latest

  # delve golang debug
  go install github.com/go-delve/delve/cmd/dlv@latest

  # mockgen
  go install go.uber.org/mock/mockgen@latest
}

shell_config_file_path="$HOME/.zshrc"

install_deb() {
    install_font() {
        echo "***************************"
        echo "* INSTALL FONTS POWERLINE *"
        echo "***************************"
      sudo apt-get install fonts-powerline
    }

    # NEO VIM
    install_neovim_if_not_exists() {
      if ! [ -x "$(command -v nvim)" ]; then
        echo "******************"
        echo "* INSTALL NEOVIM *"
        echo "******************"
	      curl -L https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz | tar -xz
        echo "**************************************"
        echo "* MOVE NEOVIM TO INSTALLED DIRECTORY *"
        echo "**************************************"
        sudo rm -rf /usr/local/nvim
        sudo mv nvim-linux64 /usr/local/nvim

        if ! grep -qxF 'export PATH=$PATH:/usr/local/nvim/bin' $shell_config_file_path; then
          echo 'export PATH=$PATH:/usr/local/nvim/bin' >> $shell_config_file_path
          echo 'Reload environment'
          source $shell_config_file_path
        fi
      fi
    }


    
    ################################
    ##### PROGRAMMING LANGUAGE #####
    ################################
    
    # GOLANG
    install_go_if_not_exists() {
      if ! [ -x "$(command -v go)" ]; then
        echo -n "Go is NOT installed."
        # snap install go --classic
        sudo wget -O - https://go.dev/dl/go1.21.6.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local/

        if ! grep -qxF 'export PATH=$PATH:/usr/local/go/bin' $shell_config_file_path
        then
          echo 'export PATH=$PATH:/usr/local/go/bin' >> $shell_config_file_path
          echo -n 'Reload environment'
          source $shell_config_file_path

          # Install go dependencies
          install_go_tool
        fi
      fi
    }

    # JAVA
    install_java_if_not_exists() {
        echo "**********************"
        echo "* INSTALL OPENJDK 18 *"
        echo "**********************"
        sudo apt install openjdk-18-jdk
    }

    # LUA
    install_lua_if_not_exists() {
      echo "***************"
      echo "* INSTALL LUA *"
      echo "***************"
      lua_version=5.4.7
      curl -L https://www.lua.org/ftp/lua-${lua_version}.tar.gz | tar zx
      cd lua-${lua_version}
      make
      sudo make install
    }
    
    # NODEJS
    install_node_if_not_exists() {
      if ! [ -x "$(command -v node)" ]; then
        echo "******************"
        echo "* INSTALL NODEJS *"
        echo "******************"
        sudo snap install node --classic
      fi
    }

    # RUST
    install_rust_if_not_exists() {
      if ! [ -x "$(command -v rustc)" ]; then
        echo "****************"
        echo "* INSTALL RUST *"
        echo "****************"
        curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
      fi
    }



    ##############################
    ##### PACKAGE MANAGEMENT #####
    ##############################
    
    install_maven_if_not_exists() {
        if ! [ -x "$(command -v mvn)" ]; then
            maven_version=3.9.9
            curl -L https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-${maven_version}-bin.tar.gz | tar xzf  -
            mv apache-maven-${maven_version} /opt
            echo 'export PATH=$PATH:/opt/apache-maven-${maven_version}/bin' >> $shell_config_file_path
            echo 'Reload environment'
            source $shell_config_file_path
        fi
    }

    ###########################
    ##### LANGUAGE SERVER #####
    ###########################

    # DEBUG PY
    install_debugpy() {
      sudo apt install python3-debugpy
    }

    # PYRIGHT
    install_pyright_if_not_exists() {
      if ! [ -x "$(command -v pyright)" ]; then
        echo "*******************"
        echo "* INSTALL PYRIGHT *"
        echo "*******************"
        sudo snap install pyright --classic
      fi
    }

    # RUST ANALYZER
    install_rust_analyzer() {
      rustup component add rust-analyzer
    }

    # TYPESCRIPT
    install_typescript_language_server() {
        sudo npm i -g typescript
        sudo npm i -g typescript-language-server
    }

    # YAML
    install_yaml_language_server_if_not_exists() {
      if ! [ -x "$(command -v yaml-language-server)" ]; then
        echo "********************************"
        echo "* INSTALL YAML LANGUAGE SERVER *"
        echo "********************************"
        sudo snap install yaml-language-server
      fi
    }


    sudo apt install -y build-essential git wget curl cmake ripgrep
    sudo apt install -y libtool-bin

    install_font

    install_neovim_if_not_exists

    ## INSTALL PROGRAMMING LANGUAGE
    install_java_if_not_exists

    install_go_if_not_exists

    install_lua_if_not_exists

    install_node_if_not_exists

    install_rust_if_not_exists

    ## INSTALL PACKAGE MANAGEMENT
    install_maven_if_not_exists

    ## INSTALL LANGUAGE SERVER
    install_debugpy

    install_pyright_if_not_exists

    install_rust_analyzer

    install_typescript_language_server

    install_yaml_language_server_if_not_exists
}

PKGTYPE=unknown
ID=`id -u`

if [ -f /etc/redhat-release ] ; then
  PKGTYPE=rpm
elif [ -f /etc/system-release ] ; then
  # If /etc/system-release is present, this is likely a distro that uses RPM.
  PKGTYPE=rpm
else
  if uname -sv | grep 'Darwin' > /dev/null; then
    PKGTYPE=pkg
  elif [ -f /usr/bin/zypper ] ; then
    PKGTYPE=sus
  else
    PKGTYPE=deb
  fi
fi

# if [ "$ID" -ne 0 ]; then
#   if ! hash sudo 2>/dev/null; then
#     echo "This script must be executed as the 'root' user or with sudo"
#     exit 1
#   else
#     echo "Switching to root user to update the package"
#     sudo -E $0 $@
#     exit 0
#   fi
# fi

case $PKGTYPE in
  deb)
    install_deb
    ;;
  sus)
    install_suse
    ;;
  rpm)
    install_rpm
    ;;
  *)
    install_pkg
esac

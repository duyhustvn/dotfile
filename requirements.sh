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
        sudo apt install -y fonts-powerline
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

    install_wayland_clipboard() {
      sudo apt install wl-clipboard
    }
    
    ################################
    ##### PROGRAMMING LANGUAGE #####
    ################################
    
    # GOLANG
    install_go_if_not_exists() {
      if ! [ -x "$(command -v go)" ]; then
        curl -L https://go.dev/dl/go1.24.2.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local/

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
        echo "* INSTALL OPENJDK 21 *"
        echo "**********************"
        sudo apt install -y openjdk-21-jdk
    }

    # LUA
    install_lua_if_not_exists() {
      if ! [ -x "$(command -v lua)" ]; then
        echo "***************"
        echo "* INSTALL LUA *"
        echo "***************"
        lua_version=5.3.5
        curl -L https://github.com/lua/lua/archive/refs/tags/v${lua_version}.tar.gz | tar zx
        cd lua-${lua_version}
        make
        sudo cp lua /usr/local/bin/lua
      fi
    }
    
    # NODEJS
    install_node_if_not_exists() {
      if ! [ -x "$(command -v node)" ]; then
        echo "******************"
        echo "* INSTALL NODEJS *"
        echo "******************"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
        \. "$HOME/.nvm/nvm.sh" # restart nvm
        nvm install 22
        source $shell_config_file_path
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
            curl -L https://dlcdn.apache.org/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz | tar xzf  -
            sudo mv apache-maven-${maven_version} /opt
            echo "export PATH=\$PATH:/opt/apache-maven-${maven_version}/bin" >> $shell_config_file_path
            echo 'Reload environment'
            source $shell_config_file_path
        fi
    }

    ###########################
    ##### LANGUAGE SERVER #####
    ###########################

    # Clang 
    install_clangd_lsp() {

     clangd_version=20.1.0
     clangd_lsp_folder=~/.config/emacs/.local/etc/lsp/clangd
     echo "check if ${clangd_lsp_folder}/clangd_${clangd_version} exists"
     if ! [ -f "${clangd_lsp_folder}/clangd_${clangd_version}/bin/clangd" ]; then
        echo "******************"
        echo "* INSTALL CLANGD *"
        echo "******************"

        mkdir -p ${clangd_lsp_folder}
        curl -L https://github.com/clangd/clangd/releases/download/${clangd_version}/clangd-linux-${clangd_version}.zip -o clangd-linux-${clangd_version}.zip
        unzip clangd-linux-${clangd_version}.zip
        mv clangd_${clangd_version} ${clangd_lsp_folder}
      fi
    }

    # DEBUG PY
    install_debugpy() {
      sudo apt install -y python3-debugpy
    }

    # PYRIGHT
    install_pyright_if_not_exists() {
      if ! [ -x "$(command -v pyright)" ]; then
        echo "*******************"
        echo "* INSTALL PYRIGHT *"
        echo "*******************"
        npm i -g pyright
      fi
    }

    # RUST ANALYZER
    install_rust_analyzer() {
        echo "********************************"
        echo "* INSTALL RUST LANGUAGE SERVER *"
        echo "********************************"
      rustup component add rust-analyzer
    }

    # TYPESCRIPT
    install_typescript_language_server() {
        echo "********************************"
        echo "* INSTALL TSLS LANGUAGE SERVER *"
        echo "********************************"
        npm i -g typescript
        npm i -g typescript-language-server
    }

    # YAML
    install_yaml_language_server_if_not_exists() {
      if ! [ -x "$(command -v yaml-language-server)" ]; then
        echo "********************************"
        echo "* INSTALL YAML LANGUAGE SERVER *"
        echo "********************************"
        npm i -g yaml-language-server
      fi
    }


    sudo apt install -y build-essential git wget curl cmake ripgrep
    sudo apt install -y libtool-bin

    install_font

    install_wayland_clipboard

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
    install_clangd_lsp

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

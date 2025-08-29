# Function to set proxy settings
roxy() {
  local proxy=$(ip route | grep default | awk '{print $3}')

  if [ -z "$proxy" ]; then
    echo -e "\e[31mCould not detect proxy IP (is hotspot on?)\e[0m"
    return 1
  fi

  local port=8080
  local socks_port=1086

  # Set GNOME proxy mode to manual
  gsettings set org.gnome.system.proxy mode 'manual'

  # Configure HTTP and HTTPS proxies
  for protocol in http https; do
    gsettings set org.gnome.system.proxy.$protocol host "$proxy"
    gsettings set org.gnome.system.proxy.$protocol port "$port"
  done

  # Configure SOCKS proxy
  gsettings set org.gnome.system.proxy.socks host "$proxy"
  gsettings set org.gnome.system.proxy.socks port "$socks_port"

  echo -e "\e[32m\uf14a proxy set in gnome settings successfully $proxy\e[0m"
  echo ""

  # Call varproxy to set environment variables and package manager configs
  use_proxy
  # Update user-level proxychains config for Node.js
  update_proxychain "$proxy" "$port" "$socks_port"
}

# Function to set proxy environment variables and package manager configs
use_proxy() {
  # Get proxy settings from GNOME
  local http_host=$(gsettings get org.gnome.system.proxy.http host | tr -d "'")
  local http_port=$(gsettings get org.gnome.system.proxy.http port)
  local socks_host=$(gsettings get org.gnome.system.proxy.socks host | tr -d "'")
  local socks_port=$(gsettings get org.gnome.system.proxy.socks port)

  # Set environment variables
  export http_proxy="http://$http_host:$http_port"
  export https_proxy="http://$http_host:$http_port"
  export socks_proxy="socks://$socks_host:$socks_port"
  export HTTP_PROXY="$http_proxy"
  export HTTPS_PROXY="$https_proxy"
  export SOCKS_PROXY="$socks_proxy"

  # Set npm proxy configurations
  npm config set proxy "$http_proxy"
  npm config set https-proxy "$https_proxy"

  # Set pnpm proxy configurations
  if command -v pnpm >/dev/null 2>&1; then
    pnpm config set proxy "$http_proxy"
    pnpm config set https-proxy "$https_proxy"
  fi

  # Set yarn proxy configurations
  if command -v yarn >/dev/null 2>&1; then
    yarn config set proxy "$http_proxy"
    yarn config set https-proxy "$https_proxy"
  fi

  # Set git global proxy configuration
  git config --global http.proxy "$http_proxy"
  git config --global https.proxy "$https_proxy"

  echo -e "\e[92m\uf14a proxy environment variables exported\e[0m"
  echo -e "\e[92m\uf14a npm/pnpm/yarn proxy configurations set\e[0m"
  echo -e "\e[92m\uf14a git global proxy configuration set\e[0m"
  echo ""
}
# Function to unset proxy settings
unsetproxy() {
  # Reset GNOME proxy settings
  gsettings set org.gnome.system.proxy mode 'none'

  # Unset environment variables
  unset http_proxy https_proxy socks_proxy HTTP_PROXY HTTPS_PROXY SOCKS_PROXY

  # Unset npm proxy configurations
  npm config delete proxy
  npm config delete https-proxy

  # Unset pnpm proxy configurations
  if command -v pnpm >/dev/null 2>&1; then
    pnpm config delete proxy
    pnpm config delete https-proxy
  fi

  # Unset yarn proxy configurations
  if command -v yarn >/dev/null 2>&1; then
    yarn config delete proxy
    yarn config delete https-proxy
  fi

  # Unset git global proxy configuration
  git config --global --unset http.proxy
  git config --global --unset https.proxy

  echo -e "\e[32m\uf14a Proxy settings and environment variables unset successfully\e[0m"
  echo -e "\e[32m\uf14a npm/pnpm/yarn proxy configurations unset successfully\e[0m"
  echo -e "\e[32m\uf14a git global proxy configuration unset successfully\e[0m"
}

update_proxychain() {
  local proxy_ip=$1
  local http_port=$2
  local sock_port=$3

  mkdir -p "$HOME/.config"
  local config_file="$HOME/.config/proxychains.conf"

  cat >"$config_file" <<EOF
strict_chain
proxy_dns
tcp_read_time_out 15000
tcp_connect_time_out 8000

[ProxyList]
http $proxy_ip $http_port
socks4 $proxy_ip $sock_port
socks5 $proxy_ip $sock_port
EOF

  echo -e "\e[32m\uf14a Proxychains configuration updated successfully\e[0m"
}

alias pxc='proxychains4 -f ~/.config/proxychains.conf'
alias gitproxy='GIT_SSH_COMMAND='\''ssh -o ProxyCommand="connect -H $http_proxy %h %p"'\'' git'

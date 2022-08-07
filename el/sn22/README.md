
sed -i 's/bullseye/sid/' /etc/apt/sources.list;
yes | apt update && yes | apt full-upgrade;
yes | apt install tmux elixir erlang inotify-tools wrk certbot nginx docker postgresql cmake;






////////////////

certbot certonly;
git pull; mix assets.deploy; MIX_ENV=prod iex --name ? -S mix phx.server;
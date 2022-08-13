
sed -i 's/bullseye/sid/' /etc/apt/sources.list;
yes | apt update && yes | apt full-upgrade; 
yes | apt install tmux elixir erlang inotify-tools wrk certbot docker postgresql cmake git;
git clone https://github.com/lys-2/aa;
cd aa/el/sn22/;

mix deps.get;
mix local.rebar --force;




////////////////

certbot certonly;
git pull; yes | mix local.hex && mix deps.get; mix assets.deploy; MIX_ENV=prod iex --name ? -S mix phx.server;

//////////////////////////
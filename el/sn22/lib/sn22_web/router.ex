defmodule Sn22Web.Router do
  use Sn22Web, :router
  import Phoenix.LiveView.Router
  import Plug.BasicAuth



  def auth(conn, _opts) do

    # {:ok, pw} = File.read System.user_home <> "/1"
    # if 1 == conn.params["pw"] do
    #   IO.puts "aaa"
    # end
    # put_resp_cookie(conn, "u", "2", max_age: 360000)
    # text(conn, 1)
    q = M7state.get_user get_session(conn, :user)
    # conn = assign conn, :info
    # conn = conn |> put_flash(:info, "Logged in");

    case q do
      {:ok, _} -> conn
      # {:ok, _} -> {_, u} = q; conn |> put_session(:user, u.id)
      _ -> conn |> put_session(:user, 2)

    end

    # delete_session(conn, :user)
    # |> put_session(:user, 2)
    # |> Plug.BasicAuth.basic_auth(username: "an", password: "")
#
  end

  pipeline :browser do
    # plug :basic_auth, username: "an", password: ""
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Sn22Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :auth


  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Sn22Web do

    pipe_through :browser
    # live "/v",
    live_session :default do
      live "/ts", ThermostatLive
      live "/st", Store
  end
    post "/reg", PageController, :reg
    post "/logout", PageController, :logout
    post "/log", PageController, :log
    get "/", PageController, :index
    get "/p", PageController, :p
    get "/rq", PageController, :rq
    get "/rq1", PageController, :rq1
    get "/g", PageController, :new
    get "/v", PageController, :v
    get "/sm", PageController, :sm
    get "/sb", PageController, :sb
    get "/ls", PageController, :ls

  end

  # Other scopes may use custom stacks.
  # scope "/api", Sn22Web do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Sn22Web.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

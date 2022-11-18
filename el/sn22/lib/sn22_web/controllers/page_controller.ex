defmodule Sn22Web.PageController do
  use Sn22Web, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    render(conn, "index.html")
  end

  def reg(conn, _p) do
    id = M7state.add_user %M7user{name: conn.params["name"] || Faker.Person.name, pw:
    conn.params["pw"]}
    conn = put_session(conn, :user, id)
    redirect(conn, to: "/st")
   end

   def log(conn, _p) do
    # text(conn, :ok)
    # redirect(conn, to: "/st")
    q = M7state.get_user conn.params["id"]
    id = get_session(conn, :user)
    case q do
      {:ok, _} ->
        {_, u} = q;
        case M7state.check u, conn.params["key"] do
        true -> redirect(put_session(conn, :user, u.id), to: "/st")
        _ -> M7state.info id, "Wrong!";

        :timer.apply_after(5000, M7state, :info, [id, ""]);
         redirect(conn, to: "/st")
        end
      # 1 -> redirect(put_session(conn, :user, 3), to: "/st")
      # 2 -> redirect(put_session(conn, :user, "111"), to: "/st")
      _ ->;
        M7state.info id, "Missing id";
        :timer.apply_after(5000, M7state, :info, [id, ""]);
       redirect(conn, to: "/st")
    end
   end

   def logout(conn, _p) do
    delete_session(conn, :user)
   end

  def gd(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    render(conn, "gd.html")
  end

  def ls(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    render(conn, "ls.html")
  end

  def sm(conn, _params) do render(conn, "sm.html") end
  def sb(conn, _params) do
    conn |>
    # put_flash(:error, M3.get) |>
    render "sb.html" end

    defmodule User do
      use Ecto.Schema

      schema "users" do
        field :name, :string
        field :age, :integer, default: 0
        field :password, :string, redact: true
        has_many :posts, Post
      end
    end

    def new(conn, _params) do
      render conn, "gd.html", changeset: Ecto.Changeset.cast(%User{}, %{}, [:name, :age])
    end

  def rq(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    text(conn, inspect conn.params["time"]
     )
  end

  def rq1(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    text(conn, M2.get
     )
  end

  def p(conn, _params) do
    if conn.params["say"] |> String.length > 99 do text(conn, "message too long")
    else
      if Process.whereis(:mb) |> Process.info(:messages) |> elem(1) |> length > 49 do
      Process.whereis(:mb) |> Process.exit(1);
      Process.unregister(:mb);
      spawn(Sn22, :run, []) |> Process.register(:mb)
      end
      Process.whereis(:mb) |> send(conn.params["say"])
      redirect(conn, to: "/")
  end

  end
end

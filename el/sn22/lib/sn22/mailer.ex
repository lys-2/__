defmodule Sn22.Mailer do
  use Swoosh.Mailer, otp_app: :sn22
end

defmodule Sn22.UserEmail do
  import Swoosh.Email

  def welcome(user) do
    new()
    |> to({user.name, user.email})
    |> from({"Dr B Banner", "hulk.smash@example.com"})
    |> subject("Hello, Avengers!")
    |> html_body("<h1>Hello #{user.name}</h1>")
    |> text_body("Hello #{user.name}\n")
  end
end

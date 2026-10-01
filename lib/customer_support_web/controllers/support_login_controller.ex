defmodule CustomerSupportWeb.SupportLoginController do
  use CustomerSupportWeb, :controller

  alias CustomerSupport.SupportUsers

  def create(conn, %{"support_user" => %{"email" => email, "password" => password}}) do
    case SupportUsers.authenticate_support_user(email, password) do
      {:ok, support_user} ->
        conn
        |> put_session(:support_user_id, support_user.support_user_id)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: ~p"/support/dashboard")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> redirect(to: ~p"/support/login")
    end
  end
end

defmodule CustomerSupportWeb.ManagerLoginController do
  use CustomerSupportWeb, :controller

  alias CustomerSupport.SupportManagers

  def create(conn, %{"manager" => %{"email" => email, "password" => password}}) do
    case SupportManagers.authenticate_manager(email, password) do
      {:ok, manager} ->
        conn
        |> put_session(:manager_id, manager.manager_id)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: ~p"/support/manager/dashboard")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> redirect(to: ~p"/support/login")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/support/login")
  end
end

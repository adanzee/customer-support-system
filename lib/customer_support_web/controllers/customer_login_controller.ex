defmodule CustomerSupportWeb.CustomerLoginController do
  use CustomerSupportWeb, :controller

  alias CustomerSupport.Accounts

  def create(conn, %{"customer" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_customer(email, password) do
      {:ok, customer} ->
        conn
        |> put_session(:customer_id, customer.customer_id)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: ~p"/dashboard")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> redirect(to: ~p"/login")
    end
  end
end

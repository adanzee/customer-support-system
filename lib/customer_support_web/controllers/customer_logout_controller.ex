defmodule CustomerSupportWeb.CustomerLogoutController do
  use CustomerSupportWeb, :controller

  def logout(conn, _params) do
    conn
    |> delete_session(:customer_id)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: ~p"/login")
  end
end

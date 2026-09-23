defmodule CustomerSupportWeb.CustomerSessionController do
  use CustomerSupportWeb, :controller

  def create(conn, %{"id" => customer_id}) do
    conn
    |> put_session(:customer_id, String.to_integer(customer_id))
    |> redirect(to: "/")
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/login")
  end
end

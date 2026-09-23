defmodule CustomerSupportWeb.Plugs.CustomerAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias CustomerSupport.Accounts

  def init(opts) do
    opts
  end

  def call(conn, :fetch_current_customer) do
    customer_id = get_session(conn, :customer_id)

    customer =
      if customer_id do
        Accounts.get_customer(customer_id)
      end

    assign(conn, :current_customer, customer)
  end

  def call(conn, :require_authenticated_customer) do
    if conn.assigns[:current_customer] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: "/login")
      |> halt()
    end
  end
end

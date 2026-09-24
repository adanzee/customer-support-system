defmodule CustomerSupportWeb.Plugs.CustomerAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias CustomerSupport.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :customer_id) do
      nil ->
        conn
        |> put_session(:auth_error, "Please log in first.")
        |> redirect("/login")
        |> halt()

      customer_id ->
        case Accounts.get_customer(customer_id) do
          nil ->
            conn
            |> delete_session(:customer_id)
            |> put_session(:auth_error, "Please log in again.")
            |> redirect("/login")
            |> halt()

          customer ->
            assign(conn, :current_customer, customer)
        end
    end
  end
end

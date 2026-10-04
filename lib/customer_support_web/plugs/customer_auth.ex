defmodule CustomerSupportWeb.Plugs.CustomerAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias CustomerSupport.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      get_session(conn, :staff_id) != nil ->
        conn
        |> put_flash(:error, "You are not authorized to access this portal.")
        |> redirect(to: "/support/staff/dashboard")
        |> halt()

      get_session(conn, :manager_id) != nil ->
        conn
        |> put_flash(:error, "You are not authorized to access this portal.")
        |> redirect(to: "/support/manager/dashboard")
        |> halt()

      is_nil(get_session(conn, :customer_id)) ->
        conn
        |> put_flash(:error, "Please log in first.")
        |> redirect(to: "/login")
        |> halt()

      true ->
        customer_id = get_session(conn, :customer_id)

        case Accounts.get_customer(customer_id) do
         nil ->
          conn
          |> delete_session(:customer_id)
          |> put_flash(:error, "Please log in again.")
          |> redirect(to: "/login")
          |> halt()
          customer ->
            assign(conn, :current_customer, customer)
        end
    end
  end
end

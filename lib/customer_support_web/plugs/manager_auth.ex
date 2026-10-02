defmodule CustomerSupportWeb.Plugs.ManagerAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias CustomerSupport.SupportManagers

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :manager_id) do
      nil ->
        conn
        |> put_flash(:error, "Please log in to continue.")
        |> redirect(to: "/support/login")
        |> halt()

      manager_id ->
        case SupportManagers.get_manager(manager_id) do
          nil ->
            conn
            |> put_flash(:error, "Please log in to continue.")
            |> redirect(to: "/support/login")
            |> halt()

          manager ->
            assign(conn, :current_manager, manager)
        end
    end
  end
end

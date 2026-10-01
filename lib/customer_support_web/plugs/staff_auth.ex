defmodule CustomerSupportWeb.Plugs.StaffAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias CustomerSupport.SupportStaff

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :staff_id) do
      nil ->
        conn
        |> put_flash(:error, "Please log in to continue.")
        |> redirect(to: "/support/login")
        |> halt()

      staff_id ->
        case SupportStaff.get_staff(staff_id) do
          nil ->
            conn
            |> put_flash(:error, "Please log in to continue.")
            |> redirect(to: "/support/login")
            |> halt()

          staff ->
            assign(conn, :current_staff, staff)
        end
    end
  end
end

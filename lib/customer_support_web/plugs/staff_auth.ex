defmodule CustomerSupportWeb.Plugs.StaffAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias CustomerSupport.SupportStaff

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      get_session(conn, :customer_id) != nil ->
        conn
        |> put_flash(:error, "You are not authorized to access this portal.")
        |> redirect(to: "/login")
        |> halt()

      get_session(conn, :manager_id) != nil ->
        conn
        |> put_flash(:error, "You need to be staff member to access this portal.")
        |> redirect(to: "/support/manager/dashboard")
        |> halt()

      is_nil(get_session(conn, :staff_id)) ->
        conn
        |> put_flash(:error, "Please log in to continue.")
        |> redirect(to: "/support/staff/login")
        |> halt()

      true ->
        staff_id = get_session(conn, :staff_id)

        case SupportStaff.get_staff(staff_id) do
          nil ->
            conn
            |> put_flash(:error, "Please log in to continue.")
            |> redirect(to: "/support/staff/login")
            |> halt()

          staff ->
            assign(conn, :current_staff, staff)
        end
    end
  end
end

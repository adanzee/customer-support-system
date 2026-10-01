defmodule CustomerSupportWeb.StaffAuthHook do
  import Phoenix.LiveView
  import Phoenix.Component

  alias CustomerSupport.SupportStaff

  def on_mount(:default, _params, session, socket) do
    case session["staff_id"] do
      nil ->
        {:halt, redirect(socket, to: "/support/staff/login")}

      staff_id ->
        case SupportStaff.get_staff(staff_id) do
          nil ->
            {:halt, redirect(socket, to: "/support/staff/login")}

          staff ->
            {:cont, assign(socket, :current_staff, staff)}
        end
    end
  end
end

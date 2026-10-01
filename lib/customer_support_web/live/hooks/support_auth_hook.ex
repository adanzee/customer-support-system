defmodule CustomerSupportWeb.SupportAuthHook do
  import Phoenix.LiveView
  import Phoenix.Component

  alias CustomerSupport.SupportUsers

  def on_mount(:default, _params, session, socket) do
    case session["support_user_id"] do
      nil ->
        {:halt, redirect(socket, to: "/support/login")}

      support_user_id ->
        case SupportUsers.get_support_user(support_user_id) do
          nil ->
            {:halt, redirect(socket, to: "/support/login")}

          support_user ->
            {:cont, assign(socket, :current_support_user, support_user)}
        end
    end
  end

  def on_mount(:manager, _params, _session, socket) do
    if socket.assigns.current_support_user.role == :manager do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/support/dashboard")}
    end
  end
end

defmodule CustomerSupportWeb.ManagerAuthHook do
  import Phoenix.LiveView
  import Phoenix.Component

  alias CustomerSupport.SupportManagers

  def on_mount(:default, _params, session, socket) do
    case session["manager_id"] do
      nil ->
        {:halt, redirect(socket, to: "/support/login")}

      manager_id ->
        case SupportManagers.get_manager(manager_id) do
          nil ->
            {:halt, redirect(socket, to: "/support/login")}

          manager ->
            {:cont, assign(socket, :current_manager, manager)}
        end
    end
  end
end

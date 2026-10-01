defmodule CustomerSupportWeb.Plugs.SupportAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias CustomerSupport.SupportUsers

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :support_user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please log in to continue.")
        |> Phoenix.Controller.redirect(to: "/support/login")
        |> halt()

      support_user_id ->
        case SupportUsers.get_support_user(support_user_id) do
          nil ->
            conn
            |> put_flash(:error, "Please log in to continue.")
            |> Phoenix.Controller.redirect(to: "/support/login")
            |> halt()

          support_user ->
            assign(conn, :current_support_user, support_user)
        end
    end
  end
end

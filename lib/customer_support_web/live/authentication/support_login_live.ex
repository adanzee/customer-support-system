defmodule CustomerSupportWeb.SupportLoginLive do
  use CustomerSupportWeb, :live_view



  def mount(_params, _session, socket) do
    {:ok,
    socket}
  end



  def render(assigns) do
    ~H"""
    <div>
      <h1>Support Login</h1>

      <form action={~p"/support/login"} method="post">
        <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />

        <div>
          <label>Email</label>
          <input type="email" name="support_user[email]" required />
        </div>

        <div>
          <label>Password</label>
          <input type="password" name="support_user[password]" required />
        </div>

        <button type="submit">Login</button>
      </form>

    </div>
    """
  end

end

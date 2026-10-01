defmodule CustomerSupportWeb.StaffLoginLive do
  use CustomerSupportWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Staff Login</h1>

      <.form for={%{}} action="/support/staff/login" method="post">
        <div>
          <label>Email</label>
          <input type="email" name="staff[email]" required />
        </div>

        <div>
          <label>Password</label>
          <input type="password" name="staff[password]" required />
        </div>

        <button type="submit">Login</button>
      </.form>
    </div>
    """
  end
end

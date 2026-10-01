defmodule CustomerSupportWeb.StaffDashboardLive do
  use CustomerSupportWeb, :live_view

  on_mount {CustomerSupportWeb.StaffAuthHook, :default}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Staff Dashboard</h1>

      <p>Welcome, <%= @current_staff.name %></p>
      <p>Email: <%= @current_staff.email %></p>
      <p>Staff ID: <%= @current_staff.staff_identifier %></p>


      <form action="/support/staff/logout" method="post">
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
        <button type="submit">Logout</button>
      </form>
    </div>
    """
  end
end

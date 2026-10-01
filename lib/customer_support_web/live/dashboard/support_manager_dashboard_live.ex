defmodule CustomerSupportWeb.SupportManagerDashboardLive do
  use CustomerSupportWeb, :live_view

  on_mount {CustomerSupportWeb.SupportAuthHook, :default}
  on_mount {CustomerSupportWeb.SupportAuthHook, :manager}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Support Manager Dashboard</h1>

      <p>Welcome, <%= @current_support_user.name %></p>
      <p>Email: <%= @current_support_user.email %></p>
      <p>Role: <%= @current_support_user.role %></p>
    </div>
    """
  end
end

defmodule CustomerSupportWeb.SupportManagerDashboardLive do
  use CustomerSupportWeb, :live_view

on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

 def render(assigns) do
  ~H"""
  <div>
    <h1>Support Manager Dashboard</h1>

    <p>Welcome, <%= @current_manager.name %></p>
    <p>Email: <%= @current_manager.email %></p>
    <p>Manager ID: <%= @current_manager.manager_identifier %></p>

    <h2>Management</h2>

    <p>
      <.link navigate={~p"/support/manager/requests"}>
        Customer Requests
      </.link>
    </p>

    <p>
      <.link navigate={~p"/support/manager/staff"}>
        Support Staff
      </.link>
    </p>
  </div>
  """
end
end

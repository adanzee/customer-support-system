defmodule CustomerSupportWeb.SupportDashboardLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportUsers

  on_mount {CustomerSupportWeb.SupportAuthHook, :default}

  def mount(_params, session, socket) do
    support_user_id = session["support_user_id"]

    support_user = SupportUsers.get_support_user(support_user_id)

    {:ok, assign(socket, :support_user, support_user)}
  end

 def render(assigns) do
    ~H"""
    <div>
      <h1>Support Dashboard</h1>

      <p>Welcome, <%= @current_support_user.name %></p>
      <p>Email: <%= @current_support_user.email %></p>
      <p>Role: <%= @current_support_user.role %></p>
    </div>
    """
  end
end

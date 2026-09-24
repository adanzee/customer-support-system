defmodule CustomerSupportWeb.CustomerDashboardLive do
  use CustomerSupportWeb, :live_view


  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Customer Dashboard</h1>
      <p>Customer portal dashboard.</p>
    </div>
    """
  end
end

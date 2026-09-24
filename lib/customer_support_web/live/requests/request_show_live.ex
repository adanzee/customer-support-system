defmodule CustomerSupportWeb.RequestShowLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests

  def mount(%{"id" => request_id}, _session, socket) do
    request = Requests.get_request(request_id)

    {:ok, assign(socket, :request, request)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Request Details</h1>

      <%= if @request do %>
        <div>
          <p><strong>Request ID:</strong> <%= @request.request_id %></p>
          <p><strong>Title:</strong> <%= @request.title %></p>
          <p><strong>Description:</strong> <%= @request.description %></p>
          <p><strong>Category:</strong> <%= @request.category %></p>
          <p><strong>Status:</strong> <%= @request.status %></p>
          <p><strong>Priority:</strong> <%= @request.priority %></p>
          <p><strong>Created:</strong> <%= @request.inserted_at %></p>
          <p><strong>Updated:</strong> <%= @request.updated_at %></p>
        </div>
      <% else %>
        <p>Request not found.</p>
      <% end %>
    </div>
    """
  end
end

defmodule CustomerSupportWeb.RequestIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests

  def mount(_params, _session, socket) do
    customer_id = "89feebf7-895c-428b-88aa-6d0cfbc3b240"

    requests = Requests.list_requests_by_customer(customer_id)

    {:ok, assign(socket, :requests, requests)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>My Requests</h1>

      <%= if @requests == [] do %>
        <p>You have not submitted any requests yet.</p>
      <% else %>
        <table>
          <thead>
            <tr>
              <th>Request ID</th>
              <th>Title</th>
              <th>Category</th>
              <th>Status</th>
              <th>Priority</th>
              <th>Created</th>
            </tr>
          </thead>

          <tbody>
            <%= for request <- @requests do %>
              <tr>
                <td>
                  <.link navigate={~p"/requests/#{request.request_id}"}>
                    <%= request.request_id %>
                  </.link>
                </td>
                <td><%= request.title %></td>
                <td><%= request.category %></td>
                <td><%= request.status %></td>
                <td><%= request.priority %></td>
                <td><%= request.inserted_at %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      <% end %>
    </div>
    """
  end
end

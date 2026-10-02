defmodule CustomerSupportWeb.StaffDashboardLive do
  use CustomerSupportWeb, :live_view

  on_mount {CustomerSupportWeb.StaffAuthHook, :default}

  def mount(_params, _session, socket) do
    requests =
      CustomerSupport.SupportStaff.list_assigned_requests(
        socket.assigns.current_staff.staff_id
      )

    {:ok, assign(socket, :requests, requests)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Staff Dashboard</h1>

      <p>Welcome, <%= @current_staff.name %></p>
      <p>Email: <%= @current_staff.email %></p>
      <p>Staff ID: <%= @current_staff.staff_identifier %></p>
      <h2>Assigned Requests</h2>

          <%= if @requests == [] do %>
            <p>No requests assigned to you.</p>
          <% else %>
            <table>
              <thead>
                <tr>
                  <th>Request</th>
                  <th>Title</th>
                  <th>Customer</th>
                  <th>Category</th>
                  <th>Status</th>
                  <th>Priority</th>
                </tr>
              </thead>

              <tbody>
                <%= for request <- @requests do %>
                  <tr>
                    <td>
                    <.link navigate={~p"/support/staff/requests/#{request.request_id}"}>
                      <%= request.request_id %>
                    </.link>
                    </td>
                    <td><%= request.title %></td>
                    <td><%= request.customer.name %></td>
                    <td><%= request.category %></td>
                    <td><%= request.status %></td>
                    <td><%= request.priority %></td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          <% end %>


      <form action="/support/staff/logout" method="post">
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
        <button type="submit">Logout</button>
      </form>
    </div>
    """
  end
end

defmodule CustomerSupportWeb.StaffIndexLive do
  use CustomerSupportWeb, :live_view

  on_mount {CustomerSupportWeb.SupportAuthHook, :default}
  on_mount {CustomerSupportWeb.SupportAuthHook, :manager}

  alias CustomerSupport.SupportUsers

  def mount(_params, _session, socket) do
    staff = SupportUsers.list_staff()

    {:ok, assign(socket, :staff, staff)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Support Staff</h1>

      <%= if @staff == [] do %>
        <p>No support staff found.</p>
      <% else %>
        <table>
          <thead>

          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Created At</th>
            <th>Support User ID</th>
          </tr>

          </thead>

          <tbody>
            <%= for staff <- @staff do %>
              <tr>
                <td><%= staff.name %></td>
                <td><%= staff.email %></td>
                <td><%= staff.role %></td>
                <td><%= staff.inserted_at %></td>
                <td><%= staff.support_user_id %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      <% end %>
    </div>
    """
  end
end

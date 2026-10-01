defmodule CustomerSupportWeb.StaffIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(_params, _session, socket) do
    staff = SupportStaff.list_staff()

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
              <th>Staff Identifier</th>
              <th>Name</th>
              <th>Email</th>
              <th>Created At</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            <%= for staff <- @staff do %>
              <tr>
                <td><%= staff.staff_identifier %></td>
                <td><%= staff.name %></td>
                <td><%= staff.email %></td>
                <td><%= staff.inserted_at %></td>
                <td>
                  <.link navigate={~p"/support/manager/staff/#{staff.staff_id}/edit"}>
                    Edit
                  </.link>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      <% end %>
    </div>
    """
  end
end

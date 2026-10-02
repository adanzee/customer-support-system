defmodule CustomerSupportWeb.StaffIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(_params, _session, socket) do
    staff = SupportStaff.list_staff()

    {:ok, assign(socket, :staff, staff)}
  end

  def handle_event("delete_staff", %{"id" => staff_id}, socket) do
    case SupportStaff.get_staff(staff_id) do
      nil ->
        {:noreply,
        put_flash(socket, :error, "Support staff not found.")}

      staff ->
        case SupportStaff.delete_staff(staff) do
          {:ok, _staff} ->
            {:noreply,
            socket
            |> assign(:staff, SupportStaff.list_staff())
            |> put_flash(:info, "Support staff deleted successfully.")}

          {:error, _changeset} ->
            {:noreply,
            put_flash(socket, :error, "Unable to delete support staff.")}
        end
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Support Staff</h1>
      <p>
        <.link navigate={~p"/support/manager/staff/new"}>
          Create Support Staff
        </.link>
      </p>

      <p>
        <.link navigate={~p"/support/manager/dashboard"}>
          Back to Dashboard
        </.link>
      </p>

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
                <button
                  type="button"
                  phx-click="delete_staff"
                  phx-value-id={staff.staff_id}
                >
                  Delete
                </button>
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

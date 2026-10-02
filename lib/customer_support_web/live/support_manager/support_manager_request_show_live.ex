defmodule CustomerSupportWeb.SupportManagerRequestShowLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests
  alias CustomerSupport.Requests.Request
  alias CustomerSupport.SupportStaff
  alias CustomerSupport.ActivityLogs

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(%{"id" => request_id}, _session, socket) do
    case Requests.get_request(request_id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Request not found.")
         |> push_navigate(to: "/support/dashboard")}

      request ->
        request =
          Request
          |> CustomerSupport.Repo.get!(request.request_id)
          |> CustomerSupport.Repo.preload([:customer, :staff])

        staff = SupportStaff.list_staff()

        {:ok,
         socket
         |> assign(:request, request)
         |> assign(:staff, staff)}
    end
  end

def handle_event("assign_staff", %{"staff_id" => staff_id}, socket) do
  IO.inspect(staff_id, label: "ASSIGN STAFF EVENT")
  request = socket.assigns.request
  current_manager = socket.assigns.current_manager

  old_staff = request.staff

  changeset =
    Request.changeset(request, %{staff_id: staff_id})

    case CustomerSupport.Repo.update(changeset) do
      {:ok, updated_request} ->
        updated_request =
          CustomerSupport.Repo.preload(
            updated_request,
            [:customer, :staff]
          )

        action =
          cond do
            is_nil(old_staff) and updated_request.staff ->
              "request_assigned"

            old_staff && updated_request.staff ->
              "request_reassigned"

            old_staff && is_nil(updated_request.staff) ->
              "request_unassigned"

            true ->
              "request_updated"
          end

        description =
          cond do
            action == "request_assigned" ->
              "Request #{request.request_id} was assigned to #{updated_request.staff.name}."

            action == "request_reassigned" ->
              "Request #{request.request_id} was reassigned from #{old_staff.name} to #{updated_request.staff.name}."

            action == "request_unassigned" ->
              "Request #{request.request_id} was unassigned from #{old_staff.name}."

            true ->
              "Request #{request.request_id} assignment was updated."
          end

          activity_result =
            ActivityLogs.create_activity(%{
              action: action,
              description: description,
              entity_type: "request",
              entity_id: request.request_id,
              actor_type: "manager",
              actor_id: current_manager.manager_id
            })

          IO.inspect(activity_result, label: "ACTIVITY RESULT")

        {:noreply,
        socket
        |> assign(:request, updated_request)
        |> put_flash(:info, "Staff assignment updated successfully.")}

      {:error, _changeset} ->
        {:noreply,
        put_flash(socket, :error, "Unable to assign staff.")}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= if Phoenix.Flash.get(@flash, :info) do %>
        <div>
          <%= Phoenix.Flash.get(@flash, :info) %>
        </div>
      <% end %>

      <%= if Phoenix.Flash.get(@flash, :error) do %>
        <div>
          <%= Phoenix.Flash.get(@flash, :error) %>
        </div>
      <% end %>

      <h1>Request Details</h1>

      <p>
        <strong>Request ID:</strong>
        <%= @request.request_id %>
      </p>

      <p>
        <strong>Title:</strong>
        <%= @request.title %>
      </p>

      <p>
        <strong>Description:</strong>
        <%= @request.description %>
      </p>

      <p>
        <strong>Category:</strong>
        <%= @request.category %>
      </p>

      <p>
        <strong>Priority:</strong>
        <%= @request.priority %>
      </p>

      <p>
        <strong>Status:</strong>
        <%= @request.status %>
      </p>

      <h2>Assigned Staff</h2>

      <%= if @request.staff do %>
        <p>
          <%= @request.staff.staff_identifier %> -
          <%= @request.staff.name %>
        </p>
      <% else %>
        <p>Unassigned</p>
      <% end %>

      <.form for={%{}} phx-submit="assign_staff">
        <select name="staff_id">
          <option value="">Unassigned</option>

          <%= for staff <- @staff do %>
            <option value={staff.staff_id}>
              <%= staff.staff_identifier %> - <%= staff.name %>
            </option>
          <% end %>
        </select>

        <button type="submit">Assign / Reassign</button>
      </.form>

      <h2>Customer</h2>

      <p>
        <strong>Name:</strong>
        <%= @request.customer.name %>
      </p>

      <p>
        <strong>Email:</strong>
        <%= @request.customer.email %>
      </p>

      <p>
        <strong>Phone:</strong>
        <%= @request.customer.phone %>
      </p>

      <.link navigate={~p"/support/manager/dashboard"}>
        Back to Dashboard
      </.link>
    </div>
    """
  end
end

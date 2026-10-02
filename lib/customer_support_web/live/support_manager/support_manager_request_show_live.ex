defmodule CustomerSupportWeb.SupportManagerRequestShowLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests
  alias CustomerSupport.Requests.Request
  alias CustomerSupport.SupportStaff

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
    request = socket.assigns.request

    changeset =
      Request.changeset(request, %{staff_id: staff_id})

    case CustomerSupport.Repo.update(changeset) do
      {:ok, updated_request} ->
        updated_request =
          CustomerSupport.Repo.preload(
            updated_request,
            [:customer, :staff]
          )

        {:noreply,
         socket
         |> assign(:request, updated_request)
         |> put_flash(:info, "Staff assigned successfully.")}

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

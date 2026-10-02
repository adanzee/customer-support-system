defmodule CustomerSupportWeb.StaffRequestShowLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff

  on_mount {CustomerSupportWeb.StaffAuthHook, :default}

  def mount(%{"id" => request_id}, _session, socket) do
    staff_id = socket.assigns.current_staff.staff_id

    case SupportStaff.get_assigned_request(staff_id, request_id) do
      nil ->
        {:ok,
        socket
        |> put_flash(:error, "Request not found.")
        |> push_navigate(to: "/support/staff/dashboard")}

      request ->
        topic = "request:#{request_id}"

        Phoenix.PubSub.subscribe(
          CustomerSupport.PubSub,
          topic
        )

        {:ok, assign(socket, :request, request)}
    end
  end

  def handle_info({:new_message, _message}, socket) do
    staff_id = socket.assigns.current_staff.staff_id
    request_id = socket.assigns.request.request_id

    request =
      SupportStaff.get_assigned_request(staff_id, request_id)

    {:noreply, assign(socket, :request, request)}
  end

  def handle_info({:status_updated, status}, socket) do
    request = %{socket.assigns.request | status: status}

    {:noreply,
    socket
    |> assign(:request, request)
    |> put_flash(:info, "Request status updated to #{status}.")}
  end

  def handle_event("update_status", %{"status" => status}, socket) do
    staff_id = socket.assigns.current_staff.staff_id
    request_id = socket.assigns.request.request_id

    case SupportStaff.update_request_status(staff_id, request_id, status) do
      {:ok, _request} ->
        request =
          SupportStaff.get_assigned_request(staff_id, request_id)

        {:noreply,
        socket
        |> assign(:request, request)
        |> put_flash(:info, "Request status updated successfully.")}

      {:error, :request_not_found} ->
        {:noreply,
        socket
        |> put_flash(:error, "Request not found.")}

      {:error, :invalid_status_transition} ->
        {:noreply,
        put_flash(socket, :error, "Invalid status transition.")}
    end
  end

  def handle_event("send_message", %{"body" => body}, socket) do
    staff_id = socket.assigns.current_staff.staff_id
    request_id = socket.assigns.request.request_id

    case SupportStaff.create_request_message(staff_id, request_id, body) do
      {:ok, _message} ->
        request =
          SupportStaff.get_assigned_request(staff_id, request_id)

        {:noreply,
        socket
        |> assign(:request, request)
        |> put_flash(:info, "Message sent successfully.")}

      {:error, :request_not_found} ->
        {:noreply,
        put_flash(socket, :error, "Request not found.")}
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

      <p><strong>Request ID:</strong> <%= @request.request_id %></p>
      <p><strong>Title:</strong> <%= @request.title %></p>
      <p><strong>Description:</strong> <%= @request.description %></p>
      <p><strong>Category:</strong> <%= @request.category %></p>
      <p><strong>Status:</strong> <%= @request.status %></p>

        <.form for={%{}} phx-submit="update_status">
          <label>Status</label>

          <select name="status">
            <option value="Open">Open</option>
            <option value="In Progress">In Progress</option>
            <option value="Waiting for Customer">Waiting for Customer</option>
            <option value="Resolved">Resolved</option>
            <option value="Closed">Closed</option>
            <option value="Reopened">Reopened</option>
          </select>

          <button type="submit">Update Status</button>
        </.form>
      <p><strong>Priority:</strong> <%= @request.priority %></p>

      <h2>Customer</h2>

      <p><strong>Name:</strong> <%= @request.customer.name %></p>
      <p><strong>Email:</strong> <%= @request.customer.email %></p>
      <p><strong>Phone:</strong> <%= @request.customer.phone %></p>

      <h2>Conversation</h2>

        <%= if @request.messages == [] do %>
          <p>No messages yet.</p>
        <% else %>
          <%= for message <- @request.messages do %>
            <div>
              <p>
                <strong><%= message.sender_type %>:</strong>
                <%= message.body %>
              </p>

              <small><%= message.inserted_at %></small>
            </div>
          <% end %>
        <% end %>

        <h3>Reply to Customer</h3>

        <.form for={%{}} phx-submit="send_message">
          <textarea
            name="body"
            placeholder="Write your reply..."
            required
          ></textarea>

          <button type="submit">Send Reply</button>
        </.form>

      <.link navigate={~p"/support/staff/dashboard"}>
        Back to Dashboard
      </.link>
    </div>
    """
  end
end

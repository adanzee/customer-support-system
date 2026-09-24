defmodule CustomerSupportWeb.RequestNewLive do
  use CustomerSupportWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("create_request", %{"request" => request_params}, socket) do
    customer_id = "89feebf7-895c-428b-88aa-6d0cfbc3b240"

    attrs = Map.put(request_params, "customer_id", customer_id)

    case CustomerSupport.Requests.create_request(attrs) do
      {:ok, request} ->
        {:noreply,
        socket
        |> put_flash(:info, "Request created successfully.")
        |> push_navigate(to: ~p"/dashboard")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
 end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Submit a Request</h1>

      <form phx-submit="create_request">
        <div>
          <label>Title</label>
          <input type="text" name="request[title]" />
        </div>

        <div>
          <label>Description</label>
          <textarea name="request[description]"></textarea>
        </div>

        <div>
          <label>Category</label>
          <select name="request[category]">
            <option value="Technical">Technical</option>
            <option value="Billing">Billing</option>
            <option value="Account">Account</option>
            <option value="General">General</option>
            <option value="Other">Other</option>
          </select>
        </div>

        <button type="submit">Submit Request</button>
      </form>
    </div>
    """
  end
end

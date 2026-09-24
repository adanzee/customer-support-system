defmodule CustomerSupportWeb.CustomerProfileLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Accounts
  alias CustomerSupport.Accounts.Customer

  def mount(_params, _session, socket) do
    customer = Accounts.get_customer("89feebf7-895c-428b-88aa-6d0cfbc3b240")

    changeset = Customer.profile_changeset(customer, %{})

    {:ok,
    socket
    |> assign(:customer, customer)
    |> assign(:form, to_form(changeset))}
  end

  def handle_event("update_profile", %{"customer" => params}, socket) do
    case Accounts.update_customer(socket.assigns.customer, params) do
      {:ok, customer} ->
        {:noreply,
        socket
        |> assign(:customer, customer)
        |> put_flash(:info, "Profile updated successfully.")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
     <%= if @customer do %>
        <form phx-submit="update_profile">
          <div>
            <label>Name</label>
            <input
              type="text"
              name="customer[name]"
              value={@customer.name}
            />
          </div>

          <div>
            <label>Email</label>
            <input
              type="email"
              value={@customer.email}
              disabled
            />
          </div>

          <div>
            <label>Phone</label>
            <input
              type="text"
              name="customer[phone]"
              value={@customer.phone}
            />
          </div>

          <button type="submit">Save Changes</button>
        </form>
      <% else %>
        <p>Customer not found.</p>
      <% end %>
    </div>
    """
  end
end

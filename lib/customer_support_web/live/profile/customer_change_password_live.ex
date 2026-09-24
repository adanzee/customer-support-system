defmodule CustomerSupportWeb.CustomerChangePasswordLive do
  use CustomerSupportWeb, :live_view
  alias CustomerSupport.Accounts

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("change_password", %{"password" => params}, socket) do
    customer = Accounts.get_customer("89feebf7-895c-428b-88aa-6d0cfbc3b240")

    case Accounts.change_password(customer, params) do
    {:ok, customer} ->
      IO.inspect(customer, label: "PASSWORD CHANGED")

      {:noreply,
      socket
      |> put_flash(:info, "Password changed successfully.")
      |> push_navigate(to: ~p"/profile")}

    {:error, :invalid_current_password} ->
      IO.inspect(:invalid_current_password, label: "PASSWORD ERROR")

      {:noreply, put_flash(socket, :error, "Current password is incorrect.")}

    {:error, changeset} ->
      IO.inspect(changeset, label: "PASSWORD CHANGESET ERROR")

      {:noreply, put_flash(socket, :error, "Please check your new password.")}
  end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Change Password</h1>

      <form phx-submit="change_password">
        <div>
          <label>Current Password</label>
          <input
            type="password"
            name="password[current_password]"
            required
          />
        </div>

        <div>
          <label>New Password</label>
          <input
            type="password"
            name="password[new_password]"
            required
          />
        </div>

        <div>
          <label>Confirm New Password</label>
          <input
            type="password"
            name="password[new_password_confirmation]"
            required
          />
        </div>

        <button type="submit">Change Password</button>
      </form>
    </div>
    """
  end
end

defmodule CustomerSupportWeb.CustomerResetPasswordLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.PasswordResetToken

  def mount(%{"token" => token}, _session, socket) do
    case CustomerSupport.PasswordResetToken.verify_token(token) do
      {:ok, reset_token} ->
        {:ok,
        socket
        |> assign(:token, token)
        |> assign(:reset_token, reset_token)}

      {:error, _reason} ->
        {:ok,

        socket
        |> put_flash(:error, "This password reset link is invalid or has expired.")
        |> redirect(to: ~p"/login")}
    end
  end

  def handle_event("reset_password", %{"password" => params}, socket) do
    case PasswordResetToken.reset_password(socket.assigns.reset_token, params) do
      {:ok, _customer} ->
        {:noreply,
        socket
        |> put_flash(:info, "Password reset successfully. Please log in.")
        |> push_navigate(to: ~p"/login")}

      {:error, changeset} ->
        {:noreply,
        socket
        |> put_flash(:error, "Please check your new password.")
        |> assign(:changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Reset Password</h1>

      <form phx-submit="reset_password">
        <div>
          <label>New Password</label>
          <input type="password" name="password[password]" required />
        </div>

        <div>
          <label>Confirm New Password</label>
          <input type="password" name="password[password_confirmation]" required />
        </div>

        <button type="submit">Reset Password</button>
      </form>
    </div>
    """
  end
end

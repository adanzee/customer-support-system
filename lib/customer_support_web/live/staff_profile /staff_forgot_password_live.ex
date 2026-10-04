defmodule CustomerSupportWeb.StaffForgotPasswordLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff.StaffPasswordReset
  alias CustomerSupport.Mailers.StaffPasswordResetMailer

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Forgot Password")
     |> assign(:email, "")}
  end

  def handle_event("request_reset", %{"email" => email}, socket) do
    case StaffPasswordReset.create_token(email) do
      {:ok, staff, reset_token} ->
        staff
        |> StaffPasswordResetMailer.password_reset_email(reset_token)
        |> CustomerSupport.Mailer.deliver()

        {:noreply,
        socket
        |> assign(:email, "")
        |> put_flash(
          :info,
          "Password reset instructions have been sent to #{staff.email}."
        )}

      {:error, :not_found} ->
        {:noreply,
        put_flash(
          socket,
          :error,
          "No staff account exists with this email address."
        )}

      {:error, _reason} ->
        {:noreply,
        put_flash(
          socket,
          :error,
          "Something went wrong. Please try again."
        )}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-dvh bg-[#F5F0E9] text-[#112250]">

      <main class="mx-auto flex min-h-dvh max-w-md items-center px-6">

        <section class="w-full rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm">

          <h1 class="text-xl font-black text-[#112250]">
            Forgot Password
          </h1>

          <p class="mt-2 text-xs text-[#3C5070]">
            Enter your staff account email and we'll send you a password reset link.
          </p>

          <%= if Phoenix.Flash.get(@flash, :info) do %>
            <div class="mt-5 rounded-xl border border-green-300 bg-green-50 px-4 py-3 text-xs text-green-800">
              <%= Phoenix.Flash.get(@flash, :info) %>
            </div>
          <% end %>

          <%= if Phoenix.Flash.get(@flash, :error) do %>
            <div class="mt-5 rounded-xl border border-red-300 bg-red-50 px-4 py-3 text-xs text-red-800">
              <%= Phoenix.Flash.get(@flash, :error) %>
            </div>
          <% end %>

          <.form
            for={%{}}
            phx-submit="request_reset"
            class="mt-6 space-y-5"
          >

            <div>
              <label class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                Staff Email
              </label>

              <input
                type="email"
                name="email"
                value={@email}
                required
                autocomplete="email"
                class="mt-1.5 w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/30 px-3.5 py-2.5 text-xs text-[#112250] focus:border-[#112250] focus:outline-none focus:ring-1 focus:ring-[#112250]"
              />
            </div>

            <button
              type="submit"
              class="w-full rounded-xl border border-[#E0C58F] bg-[#E0C58F] px-5 py-2.5 text-xs font-mono font-bold uppercase tracking-wider text-[#112250] transition hover:bg-[#112250] hover:text-[#F5F0E9] hover:border-[#112250]"
            >
              Send Reset Link →
            </button>

          </.form>

          <div class="mt-5 text-center">
            <.link
              navigate={~p"/support/staff/login"}
              class="text-xs font-mono font-bold text-[#3C5070] hover:text-[#112250]"
            >
              ← Back to Staff Login
            </.link>
          </div>

        </section>

      </main>
    </div>
    """
  end
end

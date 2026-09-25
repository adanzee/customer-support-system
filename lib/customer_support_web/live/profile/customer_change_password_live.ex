defmodule CustomerSupportWeb.CustomerChangePasswordLive do
  use CustomerSupportWeb, :live_view
  alias CustomerSupport.Accounts

  def mount(_params, session, socket) do
    customer_id = session["customer_id"]
    customer = Accounts.get_customer(customer_id)

    {:ok, assign(socket, :customer, customer)}
  end

  def handle_event("change_password", %{"password" => params}, socket) do
    customer = socket.assigns.customer

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
      <div class="max-w-xl mx-auto space-y-6 py-4 font-sans">

    <!-- PAGE HEADER BANNER (COMPACT & VERTICAL) -->
    <div class="relative overflow-hidden rounded-3xl bg-[#112250] p-6 sm:p-8 text-[#F5F0E9] shadow-xl text-center">
      <!-- Ambient Background Glows -->
      <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
      <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

      <div class="relative z-10 flex flex-col items-center">
        <.link
          navigate={~p"/profile"}
          class="inline-flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-[#E0C58F] hover:text-[#F5F0E9] transition-colors mb-4 self-start"
        >
          <.icon name="hero-arrow-left" class="size-4" />
          Back to Profile
        </.link>

        <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-[#3C5070]/40 border border-[#E0C58F]/30 text-[#E0C58F] shadow-inner mb-3">
          <.icon name="hero-lock-closed" class="size-6" />
        </div>

        <h1 class="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#F5F0E9]">
          Change Password
        </h1>

        <p class="mt-2 text-[#D9CBC2] text-xs sm:text-sm max-w-sm">
          Update your security credentials to protect your account.
        </p>
      </div>
    </div>

    <!-- PASSWORD CARD CONTAINER -->
    <div class="overflow-hidden rounded-3xl border border-[#D9CBC2]/60 bg-white shadow-sm">

      <!-- FORM SECTION -->
      <div class="p-6 sm:p-8">
        <form phx-submit="change_password" class="space-y-7">

          <!-- CURRENT PASSWORD -->
          <div class="space-y-2">
            <label for="current_password" class="block text-sm font-bold text-[#112250]">
              Current Password <span class="text-rose-500">*</span>
            </label>

            <p class="text-xs text-[#3C5070]">
              Verify your existing password.
            </p>

            <div class="relative">
              <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#3C5070]">
                <.icon name="hero-key" class="size-4" />
              </div>

              <input
                id="current_password"
                type="password"
                name="password[current_password]"
                required
                autocomplete="current-password"
                placeholder="••••••••••••"
                class="w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 pl-11 pr-4 py-3 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
              />
            </div>
          </div>

          <!-- NEW PASSWORD -->
          <div class="space-y-2">
            <label for="new_password" class="block text-sm font-bold text-[#112250]">
              New Password <span class="text-rose-500">*</span>
            </label>

            <p class="text-xs text-[#3C5070]">
              Must be at least 8 characters long.
            </p>

            <div class="relative">
              <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#3C5070]">
                <.icon name="hero-lock-closed" class="size-4" />
              </div>

              <input
                id="new_password"
                type="password"
                name="password[new_password]"
                required
                minlength="8"
                autocomplete="new-password"
                placeholder="••••••••••••"
                class="w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 pl-11 pr-4 py-3 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
              />
            </div>
          </div>

          <!-- CONFIRM PASSWORD -->
          <div class="space-y-2">
            <label for="new_password_confirmation" class="block text-sm font-bold text-[#112250]">
              Confirm New Password <span class="text-rose-500">*</span>
            </label>

            <p class="text-xs text-[#3C5070]">
              Re-enter your new password to verify accuracy.
            </p>

            <div class="relative">
              <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#3C5070]">
                <.icon name="hero-check-circle" class="size-4" />
              </div>

              <input
                id="new_password_confirmation"
                type="password"
                name="password[new_password_confirmation]"
                required
                minlength="8"
                autocomplete="new-password"
                placeholder="••••••••••••"
                class="w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 pl-11 pr-4 py-3 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
              />
            </div>
          </div>

          <!-- STACKED VERTICAL ACTIONS -->
          <div class="flex flex-col gap-3 pt-4 border-t border-[#D9CBC2]/40">
            <button
              type="submit"
              class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-[#E0C58F] px-6 py-3.5 font-bold text-sm text-[#112250] shadow-md hover:bg-[#D9CBC2] active:scale-[0.98] transition-all duration-200"
            >
              <.icon name="hero-shield-check" class="size-4 stroke-[2.5]" />
              Update Password
            </button>

            <.link
              navigate={~p"/profile"}
              class="w-full inline-flex items-center justify-center gap-2 rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/60 px-6 py-3 font-semibold text-sm text-[#112250] hover:bg-[#D9CBC2]/50 active:scale-[0.98] transition-all duration-200"
            >
              Cancel
            </.link>
          </div>

        </form>
      </div>

    </div>

  </div>
  """
end
end

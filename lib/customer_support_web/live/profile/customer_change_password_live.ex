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
      {:ok, _customer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password changed successfully.")
         |> push_navigate(to: ~p"/profile")}

      {:error, :invalid_current_password} ->
        {:noreply,
         put_flash(socket, :error, "Current password is incorrect.")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_flash(:error, "Please check your new password.")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto space-y-8 py-4 font-sans">
      <div class="text-center">
        <h1 class="text-3xl font-bold text-[#112250]">
          Change Password
        </h1>
        <p class="mt-2 text-[#3C5070]">
          Update your account password
        </p>
      </div>

      <div class="max-w-xl mx-auto">
        <div class="rounded-2xl border border-[#D9CBC2]/50 bg-white p-8 shadow-sm">
          <form phx-submit="change_password" class="space-y-6">
            <div>
              <label
                for="current_password"
                class="block text-sm font-semibold text-[#112250] mb-2"
              >
                Current Password
              </label>

              <div class="relative">
                <input
                  type="password"
                  id="current_password"
                  name="password[current_password]"
                  class="w-full rounded-xl border border-[#D9CBC2] px-4 py-3 pr-12 text-[#112250] focus:border-[#3C5070] focus:ring-2 focus:ring-[#3C5070]/20 outline-none"
                  required
                />

                <button
                  type="button"
                  class="absolute right-3 top-1/2 -translate-y-1/2 text-[#3C5070]"
                  onclick="
                    const input = document.getElementById('current_password');
                    const show = document.getElementById('current-password-eye-show');
                    const hide = document.getElementById('current-password-eye-hide');

                    if (input.type === 'password') {
                      input.type = 'text';
                      show.classList.add('hidden');
                      hide.classList.remove('hidden');
                    } else {
                      input.type = 'password';
                      show.classList.remove('hidden');
                      hide.classList.add('hidden');
                    }
                  "
                >
                  <span id="current-password-eye-show">
                    👁
                  </span>
                  <span id="current-password-eye-hide" class="hidden">
                    🙈
                  </span>
                </button>
              </div>
            </div>

            <div>
              <label
                for="new_password"
                class="block text-sm font-semibold text-[#112250] mb-2"
              >
                New Password
              </label>

              <div class="relative">
                <input
                  type="password"
                  id="new_password"
                  name="password[new_password]"
                  class="w-full rounded-xl border border-[#D9CBC2] px-4 py-3 pr-12 text-[#112250] focus:border-[#3C5070] focus:ring-2 focus:ring-[#3C5070]/20 outline-none"
                  required
                />

                <button
                  type="button"
                  class="absolute right-3 top-1/2 -translate-y-1/2 text-[#3C5070]"
                  onclick="
                    const input = document.getElementById('new_password');
                    const show = document.getElementById('new-password-eye-show');
                    const hide = document.getElementById('new-password-eye-hide');

                    if (input.type === 'password') {
                      input.type = 'text';
                      show.classList.add('hidden');
                      hide.classList.remove('hidden');
                    } else {
                      input.type = 'password';
                      show.classList.remove('hidden');
                      hide.classList.add('hidden');
                    }
                  "
                >
                  <span id="new-password-eye-show">
                    👁
                  </span>
                  <span id="new-password-eye-hide" class="hidden">
                    🙈
                  </span>
                </button>
              </div>
            </div>

            <div>
              <label
                for="new_password_confirmation"
                class="block text-sm font-semibold text-[#112250] mb-2"
              >
                Confirm New Password
              </label>

              <div class="relative">
                <input
                  type="password"
                  id="new_password_confirmation"
                  name="password[new_password_confirmation]"
                  class="w-full rounded-xl border border-[#D9CBC2] px-4 py-3 pr-12 text-[#112250] focus:border-[#3C5070] focus:ring-2 focus:ring-[#3C5070]/20 outline-none"
                  required
                />

                <button
                  type="button"
                  class="absolute right-3 top-1/2 -translate-y-1/2 text-[#3C5070]"
                  onclick="
                    const input = document.getElementById('new_password_confirmation');
                    const show = document.getElementById('confirm-password-eye-show');
                    const hide = document.getElementById('confirm-password-eye-hide');

                    if (input.type === 'password') {
                      input.type = 'text';
                      show.classList.add('hidden');
                      hide.classList.remove('hidden');
                    } else {
                      input.type = 'password';
                      show.classList.remove('hidden');
                      hide.classList.add('hidden');
                    }
                  "
                >
                  <span id="confirm-password-eye-show">
                    👁
                  </span>
                  <span id="confirm-password-eye-hide" class="hidden">
                    🙈
                  </span>
                </button>
              </div>
            </div>

            <div class="pt-2">
              <button
                type="submit"
                class="w-full rounded-xl bg-[#112250] px-6 py-3 font-semibold text-white transition hover:bg-[#3C5070]"
              >
                Change Password
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
    """
  end
end

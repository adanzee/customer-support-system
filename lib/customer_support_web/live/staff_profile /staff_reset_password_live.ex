defmodule CustomerSupportWeb.StaffResetPasswordLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff.StaffPasswordReset

  def mount(%{"token" => token}, _session, socket) do
    case StaffPasswordReset.get_valid_token(token) do
      {:ok, reset_token} ->
        {:ok,
         socket
         |> assign(:token, token)
         |> assign(:reset_token, reset_token)
         |> assign(:reset_success, false)
         |> assign(:changeset, nil)}

      {:error, _reason} ->
        {:ok,
         socket
         |> assign(:token, token)
         |> assign(:reset_token, nil)
         |> assign(:reset_success, false)
         |> assign(:changeset, nil)}
    end
  end

  def handle_event(
        "reset_password",
        %{"password" => params},
        socket
      ) do
    case StaffPasswordReset.reset_password(
           socket.assigns.token,
           params["password"]
         ) do
      {:ok, _staff} ->
        {:noreply,
         assign(socket, :reset_success, true)}

      {:error, :invalid_token} ->
        {:noreply,
         socket
         |> assign(:reset_token, nil)
         |> put_flash(:error, "This password reset link is invalid.")}

      {:error, :expired_token} ->
        {:noreply,
         socket
         |> assign(:reset_token, nil)
         |> put_flash(:error, "This password reset link has expired.")}

      {:error, :staff_not_found} ->
        {:noreply,
         socket
         |> assign(:reset_token, nil)
         |> put_flash(:error, "Staff account could not be found.")}

      {:error, changeset} ->
        {:noreply,
         assign(socket, :changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#F8FAFC] text-[#0F172A] flex flex-col justify-center items-center p-6 font-sans selection:bg-[#3B82F6] selection:text-white relative overflow-hidden">

      <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-gradient-to-tr from-[#3B82F6]/10 via-[#F59E0B]/5 to-transparent rounded-full blur-3xl pointer-events-none">
      </div>

      <div class="max-w-md w-full space-y-8 relative z-10">

        <!-- HEADER -->
        <div class="text-center space-y-3">

          <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#1E40AF]/10 border border-[#1E40AF]/20 text-[#1D4ED8] text-[10px] font-mono uppercase tracking-widest font-bold">
            <span class="h-1.5 w-1.5 rounded-full bg-[#F59E0B]"></span>
            Staff Account Security
          </div>

          <h1 class="text-3xl font-black text-[#0F172A] tracking-tight">
            Reset Password
          </h1>

          <p class="text-xs text-[#64748B] font-light">
            Enter and confirm your new staff portal password.
          </p>

        </div>

        <!-- CARD -->
        <div class="bg-white p-8 rounded-[2rem] border border-[#E2E8F0] shadow-xl shadow-[#0F172A]/5 space-y-6">

          <%= if Phoenix.Flash.get(@flash, :error) do %>
            <div class="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-xs text-red-700">
              <%= Phoenix.Flash.get(@flash, :error) %>
            </div>
          <% end %>

          <%= if @reset_success do %>

            <!-- SUCCESS -->
            <div class="text-center py-8 space-y-4">

              <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100 text-green-600">
                ✓
              </div>

              <h2 class="text-xl font-bold text-[#0F172A]">
                Password Reset Successfully
              </h2>

              <p class="text-sm text-[#64748B]">
                Your staff portal password has been updated.
              </p>

              <.link
                navigate={~p"/support/staff/login"}
                class="inline-block mt-3 rounded-xl bg-[#1E40AF] px-6 py-3 text-xs font-bold uppercase tracking-wider text-white hover:bg-[#1D4ED8] transition"
              >
                Go to Staff Login →
              </.link>

            </div>

          <% else %>

            <%= if @reset_token do %>

              <!-- RESET FORM -->
              <form phx-submit="reset_password" class="space-y-5">

                <!-- NEW PASSWORD -->
                <div class="space-y-1.5 text-left">

                  <label class="block text-xs font-mono font-bold uppercase tracking-wider text-[#475569]">
                    New Password
                  </label>

                  <div class="relative">

                    <input
                      type="password"
                      id="reset_password"
                      name="password[password]"
                      required
                      minlength="8"
                      autocomplete="new-password"
                      placeholder="••••••••"
                      class="w-full px-4 py-3 pr-12 rounded-xl bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] text-sm placeholder-[#94A3B8] focus:outline-none focus:border-[#1D4ED8] focus:bg-white focus:ring-4 focus:ring-[#1D4ED8]/10 transition-all"
                    />

                    <button
                      type="button"
                      class="absolute right-3 top-1/2 -translate-y-1/2 text-[#64748B] hover:text-[#1D4ED8] transition-colors"
                      onclick="
                        const input = document.getElementById('reset_password');
                        const show = document.getElementById('reset-password-eye-show');
                        const hide = document.getElementById('reset-password-eye-hide');

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
                      <span id="reset-password-eye-show">
                        👁
                      </span>

                      <span id="reset-password-eye-hide" class="hidden">
                        🙈
                      </span>
                    </button>

                  </div>

                  <%= if @changeset && @changeset.errors[:password] do %>
                    <p class="text-xs text-red-500">
                      {elem(@changeset.errors[:password], 0)}
                    </p>
                  <% end %>

                </div>

                <!-- CONFIRM PASSWORD -->
                <div class="space-y-1.5 text-left">

                  <label class="block text-xs font-mono font-bold uppercase tracking-wider text-[#475569]">
                    Confirm New Password
                  </label>

                  <div class="relative">

                    <input
                      type="password"
                      id="reset_password_confirmation"
                      name="password[password_confirmation]"
                      required
                      minlength="8"
                      autocomplete="new-password"
                      placeholder="••••••••"
                      class="w-full px-4 py-3 pr-12 rounded-xl bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] text-sm placeholder-[#94A3B8] focus:outline-none focus:border-[#1D4ED8] focus:bg-white focus:ring-4 focus:ring-[#1D4ED8]/10 transition-all"
                    />

                    <button
                      type="button"
                      class="absolute right-3 top-1/2 -translate-y-1/2 text-[#64748B] hover:text-[#1D4ED8] transition-colors"
                      onclick="
                        const input = document.getElementById('reset_password_confirmation');
                        const show = document.getElementById('reset-confirm-password-eye-show');
                        const hide = document.getElementById('reset-confirm-password-eye-hide');

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
                      <span id="reset-confirm-password-eye-show">
                        👁
                      </span>

                      <span id="reset-confirm-password-eye-hide" class="hidden">
                        🙈
                      </span>
                    </button>

                  </div>

                  <%= if @changeset && @changeset.errors[:password_confirmation] do %>
                    <p class="text-xs text-red-500">
                      {elem(@changeset.errors[:password_confirmation], 0)}
                    </p>
                  <% end %>

                </div>

                <!-- RESET BUTTON -->
                <div class="pt-2">

                  <button
                    type="submit"
                    class="w-full flex items-center justify-center gap-2 py-3.5 px-6 rounded-xl bg-[#1E40AF] text-white hover:bg-[#1D4ED8] active:scale-[0.99] font-bold text-xs uppercase tracking-wider shadow-md shadow-[#1E40AF]/20 transition-all duration-200 group"
                  >
                    <span>Reset Password</span>

                    <span class="text-[#F59E0B] group-hover:translate-x-0.5 transition-transform">
                      →
                    </span>
                  </button>

                </div>

              </form>

            <% else %>

              <!-- INVALID TOKEN -->
              <div class="text-center py-8 space-y-3">

                <h2 class="text-xl font-bold text-[#0F172A]">
                  Invalid or Expired Link
                </h2>

                <p class="text-sm text-[#64748B]">
                  This password reset link is invalid or has expired.
                </p>

                <.link
                  navigate={~p"/support/staff/forgot-password"}
                  class="inline-block mt-3 text-xs font-mono font-bold text-[#1D4ED8] hover:text-[#1E40AF]"
                >
                  Request a New Link →
                </.link>

              </div>

            <% end %>

          <% end %>

          <!-- SEPARATOR -->
          <div class="pt-4 border-t border-[#E2E8F0] flex items-center justify-between">
            <div class="h-2 w-2 rotate-45 bg-[#F59E0B]"></div>
          </div>

        </div>

        <!-- FOOTER -->
        <p class="text-center text-[10px] font-mono text-[#94A3B8]">
          SECURE GATEWAY • SUPPORTDESK
        </p>

      </div>
    </div>
    """
  end
end

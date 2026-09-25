defmodule CustomerSupportWeb.CustomerResetPasswordLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.PasswordResetToken

  def mount(%{"token" => token}, _session, socket) do
    case PasswordResetToken.verify_token(token) do
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

  def handle_event("reset_password", %{"password" => params}, socket) do
    case PasswordResetToken.reset_password(socket.assigns.reset_token, params) do
      {:ok, _customer} ->
        {:noreply,
         assign(socket, :reset_success, true)}

      {:error, changeset} ->
        {:noreply,
         assign(socket, :changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#F8FAFC] text-[#0F172A] flex flex-col justify-center items-center p-6 font-sans selection:bg-[#3B82F6] selection:text-white relative overflow-hidden">

      <!-- BACKGROUND AMBIENT GLOW -->
      <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-gradient-to-tr from-[#3B82F6]/10 via-[#F59E0B]/5 to-transparent rounded-full blur-3xl pointer-events-none"></div>

      <div class="max-w-md w-full space-y-8 relative z-10">

        <!-- HEADER BRANDING & HEADING -->
        <div class="text-center space-y-3">
          <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#1E40AF]/10 border border-[#1E40AF]/20 text-[#1D4ED8] text-[10px] font-mono uppercase tracking-widest font-bold">
            <span class="h-1.5 w-1.5 rounded-full bg-[#F59E0B]"></span>
            Account Security
          </div>

          <h1 class="text-3xl font-black text-[#0F172A] tracking-tight">
            Reset Password
          </h1>

          <p class="text-xs text-[#64748B] font-light">
            Enter and confirm your new credentials to restore secure access.
          </p>
        </div>

        <!-- FORM CARD -->
        <div class="bg-white p-8 rounded-[2rem] border border-[#E2E8F0] shadow-xl shadow-[#0F172A]/5 space-y-6">

          <!-- SUCCESS STATE -->
          <%= if @reset_success do %>

            <div class="text-center py-8">
              <h2 class="text-xl font-bold text-[#0F172A]">
                Password Reset Successfully
              </h2>
            </div>

          <!-- RESET FORM STATE -->
          <% else %>

            <%= if @reset_token do %>

              <form phx-submit="reset_password" class="space-y-5">

                <!-- NEW PASSWORD -->
                <div class="space-y-1.5 text-left">
                  <label class="block text-xs font-mono font-bold uppercase tracking-wider text-[#475569]">
                    New Password
                  </label>

                  <input
                    type="password"
                    name="password[password]"
                    required
                    placeholder="••••••••"
                    class="w-full px-4 py-3 rounded-xl bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] text-sm placeholder-[#94A3B8] focus:outline-none focus:border-[#1D4ED8] focus:bg-white focus:ring-4 focus:ring-[#1D4ED8]/10 transition-all"
                  />

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

                  <input
                    type="password"
                    name="password[password_confirmation]"
                    required
                    placeholder="••••••••"
                    class="w-full px-4 py-3 rounded-xl bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] text-sm placeholder-[#94A3B8] focus:outline-none focus:border-[#1D4ED8] focus:bg-white focus:ring-4 focus:ring-[#1D4ED8]/10 transition-all"
                  />

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
              <div class="text-center py-8">
                <h2 class="text-xl font-bold text-[#0F172A]">
                  Invalid or Expired Link
                </h2>

                <p class="text-sm text-[#64748B] mt-3">
                  This password reset link is invalid or has expired.
                </p>
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

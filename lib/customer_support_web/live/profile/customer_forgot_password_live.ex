defmodule CustomerSupportWeb.CustomerForgotPasswordLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Accounts
  alias CustomerSupport.PasswordResetToken
  alias CustomerSupport.Mailer
  alias CustomerSupport.Mailers.CustomerMailer

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :message, nil)}
  end

  def handle_event("send_reset_link", %{"email" => email}, socket) do
    email = String.downcase(String.trim(email))

    case Accounts.get_customer_by_email(email) do
      nil ->
        {:noreply,
         assign(
           socket,
           :message,
           {:error, "This email address does not exist."}
         )}

      customer ->
        case PasswordResetToken.create_token(customer) do
          {:ok, token} ->
            email =
              CustomerMailer.password_reset_email(
                customer,
                token
              )

            Mailer.deliver(email)

            {:noreply,
             assign(
               socket,
               :message,
               {:success, "A password reset link has been sent to your email."}
             )}

          {:error, _changeset} ->
            {:noreply,
             assign(
               socket,
               :message,
               {:error, "Unable to send the password reset link. Please try again."}
             )}
        end
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
            navigate={~p"/login"}
            class="inline-flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-[#E0C58F] hover:text-[#F5F0E9] transition-colors mb-4 self-start"
          >
            <.icon name="hero-arrow-left" class="size-4" />
            Back to Login
          </.link>

          <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-[#3C5070]/40 border border-[#E0C58F]/30 text-[#E0C58F] shadow-inner mb-3">
            <.icon name="hero-key" class="size-6" />
          </div>

          <h1 class="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#F5F0E9]">
            Forgot Password
          </h1>

          <p class="mt-2 text-[#D9CBC2] text-xs sm:text-sm max-w-sm">
            Reset your password and regain access to your account.
          </p>
        </div>
      </div>

      <!-- MAIN CARD CONTAINER -->
      <div class="overflow-hidden rounded-3xl border border-[#D9CBC2]/60 bg-white shadow-sm">

        <!-- FORM SECTION -->
        <div class="p-6 sm:p-8">
          <form phx-submit="send_reset_link" class="space-y-6">

            <!-- EMAIL ADDRESS FIELD -->
            <div class="space-y-2">
              <label for="email" class="block text-sm font-bold text-[#112250]">
                Email Address <span class="text-rose-500">*</span>
              </label>

              <p class="text-xs text-[#3C5070]">
                Enter the email address associated with your account.
              </p>

              <div class="relative">
                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#3C5070]">
                  <.icon name="hero-envelope" class="size-4" />
                </div>

                <input
                  id="email"
                  type="email"
                  name="email"
                  required
                  autocomplete="email"
                  placeholder="you@example.com"
                  class="w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 pl-11 pr-4 py-3 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
                />
              </div>
            </div>

            <!-- ALERT MESSAGE -->
            <%= if @message do %>
              <div class={[
                "rounded-xl border p-4 transition-all duration-200",
                elem(@message, 0) == :success && "border-emerald-300 bg-emerald-50 text-emerald-900",
                elem(@message, 0) == :error && "border-rose-300 bg-rose-50 text-rose-900"
              ]}>
                <div class="flex items-start gap-3">
                  <%= if elem(@message, 0) == :success do %>
                    <.icon name="hero-check-circle" class="size-5 shrink-0 text-emerald-600 mt-0.5" />
                  <% else %>
                    <.icon name="hero-exclamation-circle" class="size-5 shrink-0 text-rose-600 mt-0.5" />
                  <% end %>

                  <p class="text-sm font-medium leading-relaxed">
                    <%= elem(@message, 1) %>
                  </p>
                </div>
              </div>
            <% end %>

            <!-- ACTIONS -->
            <div class="pt-2">
              <button
                type="submit"
                class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-[#E0C58F] px-6 py-3.5 font-bold text-sm text-[#112250] shadow-md hover:bg-[#D9CBC2] active:scale-[0.98] transition-all duration-200"
              >
                <.icon name="hero-paper-airplane" class="size-4 stroke-[2.5]" />
                Send Reset Link
              </button>
            </div>

          </form>
        </div>

      </div>

      <!-- FOOTER NAVIGATION LINK -->
      <div class="text-center pt-2">
        <span class="text-xs sm:text-sm text-[#3C5070]">
          Remember your password?
        </span>

        <.link
          navigate={~p"/login"}
          class="ml-1 text-xs sm:text-sm font-bold text-[#112250] hover:text-[#3C5070] hover:underline transition-colors"
        >
          Back to Login
        </.link>
      </div>

    </div>
    """
  end
end

defmodule CustomerSupportWeb.CustomerLoginLive do
  use CustomerSupportWeb, :live_view
  alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # Toggle function using JS commands
  defp toggle_password(js \\ %JS{}) do
    js
    # Toggle attribute between password and text
    |> JS.dispatch("type-toggle", to: "#customer_password")
    # Toggle visibility of the two icon SVGs
    |> JS.toggle(to: "#icon-eye-show")
    |> JS.toggle(to: "#icon-eye-hide")
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#F5F0E9] flex items-center justify-center p-4 sm:p-6 md:p-10 font-sans text-[#112250]">
      <div class="w-full max-w-4xl bg-white rounded-3xl shadow-2xl border border-[#D9CBC2]/50 overflow-hidden grid grid-cols-1 lg:grid-cols-12">

        <!-- LEFT BRANDING PANEL -->
        <div class="lg:col-span-5 bg-[#112250] p-8 lg:p-12 flex flex-col justify-between relative overflow-hidden text-[#F5F0E9]">
          <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
          <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

          <div class="relative z-10 mb-8 lg:mb-0">
            <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#3C5070]/40 border border-[#E0C58F]/20 text-[#E0C58F] text-xs font-semibold tracking-wider uppercase">
              <span class="w-2 h-2 rounded-full bg-[#E0C58F] animate-pulse"></span>
              Welcome Back
            </div>
          </div>

          <div class="relative z-10 my-auto py-6">
            <h2 class="text-3xl lg:text-4xl font-extrabold text-[#F5F0E9] tracking-tight leading-tight">
              Glad to see you again.
            </h2>
            <p class="mt-4 text-[#D9CBC2] text-sm leading-relaxed">
              Sign in to access your account, review recent updates, and keep managing your workspace seamlessly.
            </p>
          </div>

          <div class="relative z-10 pt-6 border-t border-[#3C5070]/60">
            <p class="text-xs text-[#D9CBC2]">
              Don't have an account?
              <a href="/register" class="font-bold text-[#E0C58F] hover:underline ml-1 inline-flex items-center gap-1 group">
                Create one
                <span class="transition-transform group-hover:translate-x-0.5">&rarr;</span>
              </a>
            </p>
          </div>
        </div>

        <!-- RIGHT FORM PANEL -->
        <div class="lg:col-span-7 p-8 lg:p-12 bg-white flex flex-col justify-center">
          <div class="max-w-md mx-auto w-full">

            <div class="mb-8">
              <h1 class="text-2xl lg:text-3xl font-black text-[#112250] tracking-tight">Sign in to your account</h1>
              <p class="text-[#3C5070] text-sm mt-1">Please enter your credentials to proceed.</p>
            </div>

            <form action="/login" method="post" class="space-y-5">
              <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

              <!-- Email Input -->
              <div>
                <label for="customer_email" class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1.5">
                  Email Address
                </label>
                <input
                  type="email"
                  id="customer_email"
                  name="customer[email]"
                  placeholder="john@example.com"
                  required
                  class="w-full px-4 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                />
              </div>

              <!-- Password Input with Client-Side Toggle -->
              <div>
                <div class="flex items-center justify-between mb-1.5">
                  <label for="customer_password" class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider">
                    Password
                  </label>
                  <.link navigate={~p"/forgot-password"} class="text-xs font-semibold text-[#3C5070] hover:text-[#112250] hover:underline transition">
                    Forgot password?
                  </.link>
                </div>

                <div class="relative">
                  <input
                    type="password"
                    id="customer_password"
                    name="customer[password]"
                    placeholder="••••••••"
                    required
                    phx-hook="PasswordToggle"
                    class="w-full pl-4 pr-12 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                  />

                  <!-- Toggle Button -->
                  <button
                    type="button"
                    phx-click={toggle_password()}
                    class="absolute inset-y-0 right-0 pr-3.5 flex items-center text-[#3C5070] hover:text-[#112250] focus:outline-none transition"
                    aria-label="Toggle password visibility"
                  >
                    <!-- Eye Icon (Default visible) -->
                    <svg id="icon-eye-show" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                    <!-- Eye Slash Icon (Default hidden) -->
                    <svg id="icon-eye-hide" class="w-5 h-5 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858-5.908A8.982 8.982 0 0112 5c4.478 0 8.268 2.943 9.542 7a10.025 10.025 0 01-4.132 5.411m-4.692-4.692a3 3 0 00-4.243-4.243" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3l18 18" />
                    </svg>
                  </button>
                </div>
              </div>

              <!-- Remember Me Checkbox -->
              <div class="flex items-center justify-between pt-1">
                <label class="flex items-center gap-2 cursor-pointer select-none">
                  <input
                    type="checkbox"
                    name="customer[remember_me]"
                    class="w-4 h-4 rounded border-[#D9CBC2] text-[#112250] focus:ring-[#E0C58F] accent-[#112250]"
                  />
                  <span class="text-xs font-medium text-[#3C5070]">Remember me on this device</span>
                </label>
              </div>

              <!-- Primary Submit Button -->
              <div class="pt-2">
                <button
                  type="submit"
                  class="w-full py-3.5 px-6 rounded-xl bg-[#E0C58F] hover:bg-[#D9CBC2] text-[#112250] font-bold text-sm tracking-wide transition-all duration-200 shadow-md hover:shadow-lg active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-[#112250] focus:ring-offset-2"
                >
                  Sign In
                </button>
              </div>

            </form>
          </div>
        </div>

      </div>
    </div>
    """
  end
end

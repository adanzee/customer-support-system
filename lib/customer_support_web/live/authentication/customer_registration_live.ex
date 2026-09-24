defmodule CustomerSupportWeb.CustomerRegistrationLive do
  use CustomerSupportWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#F5F0E9] flex items-center justify-center p-4 sm:p-6 md:p-10 font-sans text-[#112250]">
      <div class="w-full max-w-4xl bg-white rounded-3xl shadow-2xl border border-[#D9CBC2]/50 overflow-hidden grid grid-cols-1 lg:grid-cols-12">

        <!-- ========================================== -->
        <!-- LEFT BRANDING & VALUE PANEL (5 COLUMNS)    -->
        <!-- ========================================== -->
        <div class="lg:col-span-5 bg-[#112250] p-8 lg:p-12 flex flex-col justify-between relative overflow-hidden text-[#F5F0E9]">
          <!-- Geometric Background Accents -->
          <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
          <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

          <!-- Top Brand / Logo Mark -->
          <div class="relative z-10 mb-8 lg:mb-0">
            <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#3C5070]/40 border border-[#E0C58F]/20 text-[#E0C58F] text-xs font-semibold tracking-wider uppercase">
              <span class="w-2 h-2 rounded-full bg-[#E0C58F] animate-pulse"></span>
              Join Us Today
            </div>
          </div>

          <!-- Central Brand Statement -->
          <div class="relative z-10 my-auto py-6">
            <h2 class="text-3xl lg:text-4xl font-extrabold text-[#F5F0E9] tracking-tight leading-tight">
              Start your journey with us.
            </h2>
            <p class="mt-4 text-[#D9CBC2] text-sm leading-relaxed">
              Create an account to gain full access to your personalized dashboard, manage customer profiles, and stay connected.
            </p>
          </div>

          <!-- Bottom Footer / Sign-In Link -->
          <div class="relative z-10 pt-6 border-t border-[#3C5070]/60">
            <p class="text-xs text-[#D9CBC2]">
              Already have an account?
              <a href="/login" class="font-bold text-[#E0C58F] hover:underline ml-1 inline-flex items-center gap-1 group">
                Sign in
                <span class="transition-transform group-hover:translate-x-0.5">&rarr;</span>
              </a>
            </p>
          </div>
        </div>

        <!-- ========================================== -->
        <!-- RIGHT FORM PANEL (7 COLUMNS)               -->
        <!-- ========================================== -->
        <div class="lg:col-span-7 p-8 lg:p-12 bg-white flex flex-col justify-center">
          <div class="max-w-md mx-auto w-full">

            <div class="mb-8">
              <h1 class="text-2xl lg:text-3xl font-black text-[#112250] tracking-tight">Create your account</h1>
              <p class="text-[#3C5070] text-sm mt-1">Please fill in your details to register.</p>
            </div>

            <form action="/register" method="post" class="space-y-4">
              <%!-- CSRF Protection Tag for Phoenix --%>
              <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

              <!-- Full Name -->
              <div>
                <label for="customer_name" class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1">
                  Full Name
                </label>
                <div class="relative">
                  <input
                    type="text"
                    id="customer_name"
                    name="customer[name]"
                    placeholder="John Doe"
                    required
                    class="w-full px-4 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                  />
                </div>
              </div>

              <!-- Email & Phone (Grid Layout on Medium Screens) -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <!-- Email -->
                <div>
                  <label for="customer_email" class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1">
                    Email
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

                <!-- Phone -->
                <div>
                  <label for="customer_phone" class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1">
                    Phone
                  </label>
                  <input
                    type="tel"
                    id="customer_phone"
                    name="customer[phone]"
                    placeholder="+1 (555) 000-0000"
                    class="w-full px-4 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                  />
                </div>
              </div>

              <!-- Passwords (Grid Layout) -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <!-- Password -->
                <div>
                  <label for="customer_password" class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1">
                    Password
                  </label>
                  <input
                    type="password"
                    id="customer_password"
                    name="customer[password]"
                    placeholder="••••••••"
                    required
                    class="w-full px-4 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                  />
                </div>

                <!-- Confirm Password -->
                <div>
                  <label for="customer_password_confirmation" class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1">
                    Confirm Password
                  </label>
                  <input
                    type="password"
                    id="customer_password_confirmation"
                    name="customer[password_confirmation]"
                    placeholder="••••••••"
                    required
                    class="w-full px-4 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                  />
                </div>
              </div>

              <!-- Primary Submit Button -->
              <div class="pt-2">
                <button
                  type="submit"
                  class="w-full py-3.5 px-6 rounded-xl bg-[#E0C58F] hover:bg-[#D9CBC2] text-[#112250] font-bold text-sm tracking-wide transition-all duration-200 shadow-md hover:shadow-lg active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-[#112250] focus:ring-offset-2"
                >
                  Register
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

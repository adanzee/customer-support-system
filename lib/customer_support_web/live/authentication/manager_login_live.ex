defmodule CustomerSupportWeb.ManagerLoginLive do
  use CustomerSupportWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#F8FAFC] text-[#0F172A] flex items-center justify-center p-4 sm:p-6 lg:p-8 font-sans selection:bg-[#3B82F6] selection:text-white">

      <!-- MAIN CONTAINER CARD -->
      <div class="w-full max-w-4xl bg-white rounded-[2.5rem] border border-[#E2E8F0] shadow-2xl overflow-hidden grid grid-cols-1 lg:grid-cols-12 min-h-[580px]">

        <!-- LEFT BRANDING / VISUAL COLUMN -->
        <div class="lg:col-span-5 bg-gradient-to-br from-[#0F172A] via-[#1E293B] to-[#0F172A] text-white p-8 sm:p-10 flex flex-col justify-between relative overflow-hidden">

          <!-- AMBIENT LIGHT GLOWS -->
          <div class="absolute -top-16 -left-16 w-48 h-48 bg-[#3B82F6]/20 rounded-full blur-2xl pointer-events-none"></div>
          <div class="absolute -bottom-16 -right-16 w-48 h-48 bg-[#F59E0B]/10 rounded-full blur-2xl pointer-events-none"></div>

          <!-- TOP BRANDING -->
          <div class="space-y-2 relative z-10">
            <div class="flex items-center gap-2">
              <div class="h-2.5 w-2.5 rounded-full bg-[#F59E0B] ring-4 ring-[#F59E0B]/20"></div>
              <span class="text-[11px] font-mono font-bold tracking-[0.25em] uppercase text-[#94A3B8]">
                SUPPORTDESK
              </span>
            </div>
          </div>

          <!-- MIDDLE HERO TEXT -->
          <div class="my-auto py-8 space-y-4 relative z-10">
            <h1 class="text-3xl sm:text-4xl font-black tracking-tight leading-tight">
              Management <br />
              <span class="text-[#F59E0B] font-serif italic font-normal">Portal</span>
            </h1>
            <p class="text-xs text-[#94A3B8] leading-relaxed font-light">
              Access operational controls, manage agent request queues, and review real-time support analytics.
            </p>
          </div>

          <!-- BOTTOM ACCENT DETAILS -->
          <div class="pt-4 border-t border-white/10 flex items-center justify-between text-[10px] font-mono text-[#64748B] relative z-10">
            <span>SECURE GATEWAY</span>
            <div class="h-2 w-2 rotate-45 bg-[#F59E0B]"></div>
          </div>
        </div>

        <!-- RIGHT FORM COLUMN -->
        <div class="lg:col-span-7 p-8 sm:p-12 flex flex-col justify-between bg-white">

          <div class="max-w-sm mx-auto w-full my-auto space-y-8">

            <!-- HEADER -->
            <div class="space-y-1">
              <h2 class="text-2xl font-black text-[#0F172A] tracking-tight">
                Manager Login
              </h2>
              <p class="text-xs text-[#64748B] font-light">
                Sign in to manage your support operations.
              </p>
            </div>

            <!-- FORM -->
            <form
              action={~p"/support/login"}
              method="post"
              class="space-y-5"
            >
              <input
                type="hidden"
                name="_csrf_token"
                value={Phoenix.Controller.get_csrf_token()}
              />

              <!-- EMAIL INPUT -->
              <div class="space-y-1.5 text-left">
                <label
                  for="manager-email"
                  class="block text-[11px] font-mono font-bold uppercase tracking-wider text-[#475569]"
                >
                  Email Address
                </label>
                <div class="relative">
                  <input
                    id="manager-email"
                    type="email"
                    name="manager[email]"
                    required
                    placeholder="manager@company.com"
                    class="w-full px-4 py-3 rounded-xl bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] text-sm placeholder-[#94A3B8] focus:outline-none focus:border-[#1E40AF] focus:bg-white focus:ring-4 focus:ring-[#1E40AF]/10 transition-all duration-200"
                  />
                </div>
              </div>

              <!-- PASSWORD INPUT -->
              <div class="space-y-1.5 text-left">
                <label
                  for="manager-password"
                  class="block text-[11px] font-mono font-bold uppercase tracking-wider text-[#475569]"
                >
                  Password
                </label>
                <div class="relative">
                  <input
                    id="manager-password"
                    type="password"
                    name="manager[password]"
                    required
                    placeholder="••••••••"
                    class="w-full px-4 py-3 rounded-xl bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] text-sm placeholder-[#94A3B8] focus:outline-none focus:border-[#1E40AF] focus:bg-white focus:ring-4 focus:ring-[#1E40AF]/10 transition-all duration-200"
                  />
                </div>
              </div>

              <!-- SUBMIT BUTTON -->
              <div class="pt-2">
                <button
                  type="submit"
                  class="w-full flex items-center justify-center gap-2 py-3.5 px-6 rounded-xl bg-[#0F172A] text-white hover:bg-[#1E293B] active:scale-[0.99] font-bold text-xs uppercase tracking-wider shadow-lg shadow-[#0F172A]/10 transition-all duration-200 group"
                >
                  <span>Sign In</span>
                  <span class="text-[#F59E0B] group-hover:translate-x-1 transition-transform">→</span>
                </button>
              </div>
            </form>

            <!-- FOOTER NOTICE -->
            <p class="text-center text-[10px] font-mono text-[#94A3B8]">
              CUSTOMER SUPPORT MANAGEMENT SYSTEM
            </p>

          </div>

        </div>

      </div>

    </div>
    """
  end
end

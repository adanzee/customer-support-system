defmodule CustomerSupportWeb.CustomerHomeLive do
  use CustomerSupportWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#F8FAFC] text-[#0F172A] flex flex-col justify-between p-6 sm:p-10 lg:p-14 font-sans selection:bg-[#3B82F6] selection:text-white">

      <div class="max-w-6xl mx-auto w-full my-auto space-y-10">

        <!-- TOP NAVIGATION BAR -->
        <header class="flex items-center justify-between pb-6 border-b border-[#E2E8F0]">
          <div class="flex items-center gap-3">
            <div class="h-3 w-3 rounded-full bg-[#1E40AF] ring-4 ring-[#1E40AF]/15"></div>
            <span class="text-xs font-mono font-bold tracking-[0.25em] uppercase text-[#0F172A]">
              CUSTOMER SUPPORT
            </span>
          </div>


        </header>

        <!-- MAIN SPLIT CANVAS -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-stretch">

          <!-- LEFT HERO POSTER CARD -->
          <div class="lg:col-span-5 bg-gradient-to-br from-[#0F172A] via-[#1E3A8A] to-[#0F172A] text-white p-8 sm:p-12 rounded-[2.5rem] flex flex-col justify-between shadow-2xl relative overflow-hidden border border-[#1E293B]">
            <!-- Ambient Glow Effect -->
            <div class="absolute -top-12 -right-12 w-64 h-64 bg-[#3B82F6]/20 rounded-full blur-3xl pointer-events-none"></div>

            <div class="space-y-6 relative z-10">
              <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#3B82F6]/20 border border-[#3B82F6]/30 text-[#93C5FD] text-[10px] font-mono uppercase tracking-widest font-bold">
                <span class="h-1.5 w-1.5 rounded-full bg-[#60A5FA] animate-pulse"></span>
                Direct Access
              </div>

              <h1 class="text-4xl sm:text-5xl font-black leading-[1.05] tracking-tight text-white">
                Support <br />
                that keeps <br />
                <span class="text-[#F59E0B] font-serif italic font-normal">you moving.</span>
              </h1>

              <p class="text-xs sm:text-sm text-[#94A3B8] leading-relaxed font-light">
                Submit requests, track progress, and stay connected with our support team in real time.
              </p>
            </div>

            <!-- DIAMOND ACCENT AT BOTTOM OF HERO -->
            <div class="pt-8 flex items-center justify-between relative z-10 border-t border-white/10">
              <div class="h-2.5 w-2.5 rotate-45 bg-[#F59E0B] ring-4 ring-[#F59E0B]/20"></div>
              <span class="text-[10px] font-mono text-[#94A3B8] uppercase tracking-widest">GATEWAY v2.4</span>
            </div>
          </div>

          <!-- RIGHT ACTIONS & FEATURE CARDS CONTAINER -->
          <div class="lg:col-span-7 flex flex-col justify-between space-y-8">

            <!-- ACTION BUTTONS BLOCK -->
            <div class="bg-white p-6 sm:p-8 rounded-[2rem] border border-[#E2E8F0] shadow-sm space-y-4">
              <h2 class="text-xs font-mono font-bold uppercase tracking-wider text-[#475569]">
                Choose an option to continue:
              </h2>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <.link
                  navigate={~p"/login"}
                  class="flex items-center justify-between p-4 rounded-xl bg-[#1E40AF] text-white hover:bg-[#1D4ED8] transition-all duration-200 group shadow-md shadow-[#1E40AF]/10"
                >
                  <span class="text-xs font-bold uppercase tracking-wider">Get Support</span>
                  <.icon name="hero-arrow-right" class="size-4 text-[#F59E0B] group-hover:translate-x-1 transition-transform" />
                </.link>

                <.link
                  navigate={~p"/register"}
                  class="flex items-center justify-between p-4 rounded-xl bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] hover:bg-[#F1F5F9] hover:border-[#94A3B8] transition-all duration-200 group"
                >
                  <span class="text-xs font-bold uppercase tracking-wider">Create Account</span>
                  <.icon name="hero-user-plus" class="size-4 text-[#475569] group-hover:translate-x-1 transition-transform" />
                </.link>
              </div>
            </div>

            <!-- HOW CAN WE HELP GRID -->
            <div class="space-y-4">
              <p class="text-xs font-mono font-bold uppercase tracking-[0.2em] text-[#475569] text-center lg:text-left">
                HOW CAN WE HELP?
              </p>

              <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">

                <!-- CARD 1 -->
                <div class="bg-white p-5 rounded-2xl border border-[#E2E8F0] shadow-sm flex flex-col items-center text-center space-y-2 hover:border-[#3B82F6] hover:shadow-md transition-all duration-200 group">
                  <div class="h-10 w-10 rounded-xl bg-[#EFF6FF] text-[#1D4ED8] flex items-center justify-center font-bold group-hover:bg-[#1D4ED8] group-hover:text-white transition-colors">
                    <.icon name="hero-sparkles" class="size-5 text-[#F59E0B] group-hover:text-[#F59E0B]" />
                  </div>
                  <h3 class="font-bold text-xs text-[#0F172A]">New Request</h3>
                  <p class="text-[11px] text-[#64748B]">Open a ticket instantly</p>
                </div>

                <!-- CARD 2 -->
                <div class="bg-white p-5 rounded-2xl border border-[#E2E8F0] shadow-sm flex flex-col items-center text-center space-y-2 hover:border-[#3B82F6] hover:shadow-md transition-all duration-200 group">
                  <div class="h-10 w-10 rounded-xl bg-[#EFF6FF] text-[#1D4ED8] flex items-center justify-center font-bold group-hover:bg-[#1D4ED8] group-hover:text-white transition-colors">
                    <.icon name="hero-clock" class="size-5 text-[#1D4ED8] group-hover:text-white transition-colors" />
                  </div>
                  <h3 class="font-bold text-xs text-[#0F172A]">Track Requests</h3>
                  <p class="text-[11px] text-[#64748B]">Live case updates</p>
                </div>

                <!-- CARD 3 -->
                <div class="bg-white p-5 rounded-2xl border border-[#E2E8F0] shadow-sm flex flex-col items-center text-center space-y-2 hover:border-[#3B82F6] hover:shadow-md transition-all duration-200 group">
                  <div class="h-10 w-10 rounded-xl bg-[#EFF6FF] text-[#1D4ED8] flex items-center justify-center font-bold group-hover:bg-[#1D4ED8] group-hover:text-white transition-colors">
                    <.icon name="hero-check-circle" class="size-5 text-[#1D4ED8] group-hover:text-white transition-colors" />
                  </div>
                  <h3 class="font-bold text-xs text-[#0F172A]">Updates</h3>
                  <p class="text-[11px] text-[#64748B]">Real-time responses</p>
                </div>

              </div>
            </div>

            <!-- BOTTOM CALLOUT -->
            <div class="text-center lg:text-left pt-2">
              <p class="text-xs font-bold text-[#0F172A]">
                Need help with something? <span class="font-normal text-[#64748B]">We're here for you 24/7.</span>
              </p>
            </div>

          </div>

        </div>

      </div>

      <!-- FOOTER -->
      <footer class="max-w-6xl mx-auto w-full text-center text-[10px] font-mono text-[#94A3B8] pt-6">
        © <%= DateTime.utc_now().year %> SUPPORTDESK SYSTEM • ALL RIGHTS RESERVED
      </footer>

    </div>
    """
  end
end

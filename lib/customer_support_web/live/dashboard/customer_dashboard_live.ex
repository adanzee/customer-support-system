defmodule CustomerSupportWeb.CustomerDashboardLive do
  use CustomerSupportWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto space-y-10 py-4 font-sans">

      <!-- TOP BAR & HERO SECTION -->
      <div class="relative overflow-hidden rounded-3xl bg-[#112250] p-8 md:p-10 text-[#F5F0E9] shadow-xl">
        <!-- Decorative Ambient Glows -->
        <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
        <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

        <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div class="max-w-2xl">
            <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#3C5070]/40 border border-[#E0C58F]/20 text-[#E0C58F] text-xs font-semibold uppercase tracking-wider mb-4">
              <span class="w-2 h-2 rounded-full bg-[#E0C58F] animate-pulse"></span>
              Support Dashboard
            </div>

            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tight text-[#F5F0E9]">
              Welcome to Customer Support
            </h1>

            <p class="mt-3 text-[#D9CBC2] text-base leading-relaxed">
              Manage your support requests, track ongoing resolutions, or connect with our engineering team.
            </p>
          </div>

          <!-- QUICK ACCOUNT SETTINGS TOOLBAR (REPLACES CARD) -->
          <div class="flex flex-wrap sm:flex-nowrap items-center gap-2.5 bg-[#3C5070]/30 p-2 rounded-2xl border border-[#E0C58F]/10 backdrop-blur-sm self-start md:self-center">
            <.link
              navigate={~p"/profile"}
              class="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold text-[#F5F0E9] hover:bg-[#3C5070]/60 transition duration-200"
            >
              <.icon name="hero-user-circle" class="size-4 text-[#E0C58F]" />
              Profile
            </.link>

            <div class="h-4 w-px bg-[#D9CBC2]/20 hidden sm:block"></div>

             <form action={~p"/logout"} method="post" class="inline">
              <input
                type="hidden"
                name="_csrf_token"
                value={Plug.CSRFProtection.get_csrf_token()}
              />

              <button
                type="submit"
                class="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold text-[#F5F0E9] hover:bg-[#3C5070]/60 transition duration-200"
              >
                <.icon name="hero-arrow-right-on-rectangle" class="size-4 text-[#E0C58F]" />
                Logout
              </button>
            </form>
          </div>
        </div>
      </div>

      <!-- MAIN ACTION CARDS (2-COLUMN GRID) -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">

        <!-- CARD 1: MY REQUESTS -->
        <div class="group relative rounded-3xl border border-[#D9CBC2]/60 bg-white p-8 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between hover:-translate-y-1">
          <div>
            <div class="w-14 h-14 rounded-2xl bg-[#112250]/5 text-[#112250] flex items-center justify-center mb-6 group-hover:bg-[#112250] group-hover:text-[#F5F0E9] transition-colors duration-300">
              <.icon name="hero-clipboard-document-list" class="size-7" />
            </div>

            <h2 class="text-2xl font-bold text-[#112250]">
              My Requests
            </h2>

            <p class="mt-2 text-[#3C5070] text-sm leading-relaxed">
              View and track all your submitted support requests, check resolution status, and follow up with open tickets.
            </p>
          </div>

          <div class="mt-8 pt-6 border-t border-[#D9CBC2]/40 flex items-center justify-between">
            <span class="text-xs font-semibold text-[#3C5070]">Track current status</span>
            <.link
              navigate={~p"/requests"}
              class="inline-flex items-center gap-2 rounded-xl bg-[#3C5070] px-6 py-3 font-bold text-sm text-[#F5F0E9] shadow-md hover:bg-[#112250] transition-all duration-200 active:scale-[0.98]"
            >
              View Requests
              <.icon name="hero-arrow-right" class="size-4 transition-transform group-hover:translate-x-1" />
            </.link>
          </div>
        </div>

        <!-- CARD 2: NEED HELP -->
        <div class="group relative rounded-3xl border border-[#D9CBC2]/60 bg-white p-8 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between hover:-translate-y-1">
          <div>
            <div class="w-14 h-14 rounded-2xl bg-[#E0C58F]/20 text-[#112250] flex items-center justify-center mb-6 group-hover:bg-[#E0C58F] transition-colors duration-300">
              <.icon name="hero-plus" class="size-7" />
            </div>

            <h2 class="text-2xl font-bold text-[#112250]">
              Need Help?
            </h2>

            <p class="mt-2 text-[#3C5070] text-sm leading-relaxed">
              Facing an issue or need technical assistance? Submit a new ticket and our support team will assist you shortly.
            </p>
          </div>

          <div class="mt-8 pt-6 border-t border-[#D9CBC2]/40 flex items-center justify-between">
            <span class="text-xs font-semibold text-[#3C5070]">Response within 24h</span>
            <.link
              navigate={~p"/requests/new"}
              class="inline-flex items-center gap-2 rounded-xl bg-[#E0C58F] px-6 py-3 font-bold text-sm text-[#112250] shadow-md hover:bg-[#D9CBC2] transition-all duration-200 active:scale-[0.98]"
            >
              Submit a Request
              <.icon name="hero-arrow-right" class="size-4 transition-transform group-hover:translate-x-1" />
            </.link>
          </div>
        </div>

      </div>

      <!-- BOTTOM METRICS BAR -->
      <div class="rounded-2xl bg-[#F5F0E9]/60 border border-[#D9CBC2]/50 p-6 flex flex-wrap items-center justify-around gap-4 text-center">
        <div>
          <p class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">Average Response Time</p>
          <p class="text-xl font-extrabold text-[#112250] mt-1">&lt; 2 Hours</p>
        </div>
        <div class="hidden sm:block h-8 w-px bg-[#D9CBC2]"></div>
        <div>
          <p class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">Support Hours</p>
          <p class="text-xl font-extrabold text-[#112250] mt-1">24 / 7 Live Coverage</p>
        </div>
        <div class="hidden sm:block h-8 w-px bg-[#D9CBC2]"></div>
        <div>
          <p class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">Resolution Rate</p>
          <p class="text-xl font-extrabold text-[#112250] mt-1">99.4%</p>
        </div>
      </div>

    </div>
    """
  end
end

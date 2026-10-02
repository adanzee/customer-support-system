defmodule CustomerSupportWeb.SupportManagerDashboardLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.ActivityLogs
  alias CustomerSupport.Requests
  alias CustomerSupport.SupportStaff

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

def mount(_params, _session, socket) do
  socket =
    assign(socket,
      total_requests: Requests.count_requests(),
      open_requests: Requests.count_requests_by_status("Open"),
      in_progress_requests: Requests.count_requests_by_status("In Progress"),
      waiting_requests: Requests.count_requests_by_status("Waiting for Customer"),
      resolved_requests: Requests.count_requests_by_status("Resolved"),
      closed_requests: Requests.count_requests_by_status("Closed"),
      total_staff: SupportStaff.count_staff(),
      recent_activities: ActivityLogs.list_recent_activities(5)
    )

  {:ok, socket}
end

  def render(assigns) do
    ~H"""
    <div class="h-screen w-screen overflow-hidden bg-[#F8FAFC] text-[#0F172A] flex font-sans selection:bg-[#3B82F6] selection:text-white">

      <!-- SIDEBAR NAV -->
      <aside class="w-64 bg-gradient-to-b from-[#0F172A] via-[#1E293B] to-[#0F172A] text-white h-full p-6 flex flex-col justify-between border-r border-[#1E293B] shadow-xl shrink-0">
        <div class="space-y-6">
          <!-- BRAND HEADER -->
          <div class="flex items-center gap-3 pb-5 border-b border-white/10">
            <div class="h-3 w-3 rounded-full bg-[#F59E0B] ring-4 ring-[#F59E0B]/20"></div>
            <span class="text-xs font-mono font-bold tracking-[0.2em] uppercase text-white">
              SUPPORTDESK
            </span>
          </div>

          <!-- NAVIGATION LINKS -->
          <nav class="space-y-2">
            <.link
              navigate={~p"/support/manager/dashboard"}
              class="flex items-center justify-between bg-[#1E40AF] text-white rounded-xl px-4 py-3 font-semibold text-xs uppercase tracking-wider shadow-md shadow-[#1E40AF]/20 transition-all"
            >
              <span>Dashboard</span>
              <div class="h-1.5 w-1.5 rounded-full bg-[#F59E0B]"></div>
            </.link>

            <.link
              navigate={~p"/support/manager/requests"}
              class="block text-[#94A3B8] hover:text-white hover:bg-white/5 rounded-xl px-4 py-3 font-medium text-xs tracking-wider transition-all"
            >
              Requests
            </.link>

            <.link
              navigate={~p"/support/manager/staff"}
              class="block text-[#94A3B8] hover:text-white hover:bg-white/5 rounded-xl px-4 py-3 font-medium text-xs tracking-wider transition-all"
            >
              Staff
            </.link>
          </nav>
        </div>

        <!-- SIDEBAR FOOTER ACCENT -->
        <div class="pt-4 border-t border-white/10 flex items-center justify-between text-[10px] font-mono text-[#64748B]">
          <span>GATEWAY v2.4</span>
          <div class="h-2 w-2 rotate-45 bg-[#F59E0B]"></div>
        </div>
      </aside>

      <!-- MAIN CONTENT AREA -->
      <main class="flex-1 h-full flex flex-col justify-between min-w-0 overflow-hidden">

        <!-- TOP BAR -->
        <header class="bg-white border-b border-[#E2E8F0] px-8 py-3.5 flex justify-between items-center shadow-sm shrink-0">
          <div class="flex items-center gap-3">
            <span class="text-[11px] font-mono font-bold tracking-widest text-[#475569] uppercase">
              MANAGEMENT PORTAL
            </span>
          </div>

          <div class="flex items-center gap-6">
            <div class="text-right">
              <p class="font-bold text-xs text-[#0F172A]">
                <%= @current_manager.name %>
              </p>
              <p class="text-[10px] text-[#64748B] font-mono">
                <%= @current_manager.email %>
              </p>
            </div>

            <.link
              href={~p"/support/logout"}
              method="post"
              class="px-3.5 py-1.5 rounded-lg bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] hover:bg-[#0F172A] hover:text-white transition-all text-[11px] font-mono font-bold uppercase tracking-wider"
            >
              Logout
            </.link>
          </div>
        </header>

        <!-- DASHBOARD BODY CONTAINER -->
        <div class="flex-1 p-6 max-w-6xl w-full mx-auto flex flex-col justify-between overflow-hidden">

          <!-- WELCOME HEADER -->
          <div class="shrink-0 space-y-0.5">
            <h1 class="text-2xl font-black text-[#0F172A] tracking-tight">
              Welcome back, <%= @current_manager.name %>
            </h1>
            <p class="text-[11px] text-[#64748B] font-light">
              Here's an overview of your support system.
            </p>
          </div>

          <!-- TOP 3 STAT CARDS (CLICKABLE) -->
          <div class="grid grid-cols-3 gap-5 shrink-0">

            <!-- TOTAL REQUESTS CARD -->
            <.link
              navigate={~p"/support/manager/requests"}
              class="bg-white rounded-2xl border border-[#E2E8F0] p-4 shadow-sm flex flex-col justify-between space-y-2 hover:border-[#1D4ED8] hover:shadow-md transition-all group"
            >
              <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono font-bold uppercase tracking-wider text-[#475569] group-hover:text-[#1D4ED8] transition-colors">
                  Requests
                </span>
                <div class="h-2 w-2 rounded-full bg-[#1D4ED8]"></div>
              </div>
              <div class="text-3xl font-black text-[#0F172A] tracking-tight">
                <%= @total_requests %>
              </div>
            </.link>

            <!-- OPEN REQUESTS CARD -->
            <.link
              navigate={~p"/support/manager/requests?status=open"}
              class="bg-white rounded-2xl border border-[#E2E8F0] p-4 shadow-sm flex flex-col justify-between space-y-2 hover:border-[#F59E0B] hover:shadow-md transition-all group"
            >
              <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono font-bold uppercase tracking-wider text-[#475569] group-hover:text-[#F59E0B] transition-colors">
                  Open
                </span>
                <div class="h-2 w-2 rounded-full bg-[#F59E0B]"></div>
              </div>
              <div class="text-3xl font-black text-[#0F172A] tracking-tight">
                <%= @open_requests %>
              </div>
            </.link>

            <!-- STAFF CARD -->
            <.link
              navigate={~p"/support/manager/staff"}
              class="bg-white rounded-2xl border border-[#E2E8F0] p-4 shadow-sm flex flex-col justify-between space-y-2 hover:border-emerald-500 hover:shadow-md transition-all group"
            >
              <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono font-bold uppercase tracking-wider text-[#475569] group-hover:text-emerald-600 transition-colors">
                  Staff
                </span>
                <div class="h-2 w-2 rounded-full bg-emerald-500"></div>
              </div>
              <div class="text-3xl font-black text-[#0F172A] tracking-tight">
                <%= @total_staff %>
              </div>
            </.link>

          </div>

          <!-- REQUEST OVERVIEW PANEL (CLICKABLE STATUS CARDS) -->
          <div class="bg-white rounded-2xl border border-[#E2E8F0] p-5 shadow-sm space-y-3 shrink-0">
            <div class="flex items-center justify-between pb-2 border-b border-[#E2E8F0]">
              <div class="flex items-center gap-2">
                <div class="h-2 w-2 rounded-full bg-[#1E40AF]"></div>
                <h3 class="text-sm font-bold text-[#0F172A] tracking-tight">
                  Request Overview
                </h3>
              </div>
              <span class="text-[10px] font-mono text-[#94A3B8] uppercase tracking-widest">
                TOTAL: <%= @total_requests %> REQUESTS
              </span>
            </div>

            <div class="grid grid-cols-5 gap-3">

              <!-- OPEN STATUS -->
              <.link
                navigate={~p"/support/manager/requests?status=open"}
                class="bg-[#F8FAFC] p-3 rounded-xl border border-amber-200/80 space-y-1.5 hover:border-amber-400 hover:bg-amber-50/30 transition-all block group"
              >
                <div class="flex items-center justify-between">
                  <span class="text-[11px] font-semibold text-[#475569] group-hover:text-amber-800 transition-colors">Open</span>
                  <span class="h-1.5 w-1.5 rounded-full bg-amber-500"></span>
                </div>
                <div class="text-xl font-black text-[#0F172A]"><%= @open_requests %></div>
                <div class="w-full bg-amber-100 h-1 rounded-full overflow-hidden">
                  <div class="bg-amber-500 h-full rounded-full" style={"width: #{(@open_requests / @total_requests) * 100}%"}></div>
                </div>
              </.link>

              <!-- IN PROGRESS STATUS -->
              <.link
                navigate={~p"/support/manager/requests?status=in_progress"}
                class="bg-[#F8FAFC] p-3 rounded-xl border border-blue-200/80 space-y-1.5 hover:border-blue-400 hover:bg-blue-50/30 transition-all block group"
              >
                <div class="flex items-center justify-between">
                  <span class="text-[11px] font-semibold text-[#475569] group-hover:text-blue-800 transition-colors">In Progress</span>
                  <span class="h-1.5 w-1.5 rounded-full bg-blue-500"></span>
                </div>
                <div class="text-xl font-black text-[#0F172A]"><%= @in_progress_requests %></div>
                <div class="w-full bg-blue-100 h-1 rounded-full overflow-hidden">
                  <div class="bg-blue-500 h-full rounded-full" style={"width: #{(@in_progress_requests / @total_requests) * 100}%"}></div>
                </div>
              </.link>

              <!-- WAITING STATUS -->
              <.link
                navigate={~p"/support/manager/requests?status=waiting"}
                class="bg-[#F8FAFC] p-3 rounded-xl border border-purple-200/80 space-y-1.5 hover:border-purple-400 hover:bg-purple-50/30 transition-all block group"
              >
                <div class="flex items-center justify-between">
                  <span class="text-[11px] font-semibold text-[#475569] group-hover:text-purple-800 transition-colors">Waiting</span>
                  <span class="h-1.5 w-1.5 rounded-full bg-purple-500"></span>
                </div>
                <div class="text-xl font-black text-[#0F172A]"><%= @waiting_requests %></div>
                <div class="w-full bg-purple-100 h-1 rounded-full overflow-hidden">
                  <div class="bg-purple-500 h-full rounded-full" style={"width: #{(@waiting_requests / @total_requests) * 100}%"}></div>
                </div>
              </.link>

              <!-- RESOLVED STATUS -->
              <.link
                navigate={~p"/support/manager/requests?status=resolved"}
                class="bg-[#F8FAFC] p-3 rounded-xl border border-emerald-200/80 space-y-1.5 hover:border-emerald-400 hover:bg-emerald-50/30 transition-all block group"
              >
                <div class="flex items-center justify-between">
                  <span class="text-[11px] font-semibold text-[#475569] group-hover:text-emerald-800 transition-colors">Resolved</span>
                  <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>
                </div>
                <div class="text-xl font-black text-[#0F172A]"><%= @resolved_requests %></div>
                <div class="w-full bg-emerald-100 h-1 rounded-full overflow-hidden">
                  <div class="bg-emerald-500 h-full rounded-full" style={"width: #{(@resolved_requests / @total_requests) * 100}%"}></div>
                </div>
              </.link>

              <!-- CLOSED STATUS -->
              <.link
                navigate={~p"/support/manager/requests?status=closed"}
                class="bg-[#F8FAFC] p-3 rounded-xl border border-slate-200/80 space-y-1.5 hover:border-slate-400 hover:bg-slate-100/50 transition-all block group"
              >
                <div class="flex items-center justify-between">
                  <span class="text-[11px] font-semibold text-[#475569] group-hover:text-slate-800 transition-colors">Closed</span>
                  <span class="h-1.5 w-1.5 rounded-full bg-slate-400"></span>
                </div>
                <div class="text-xl font-black text-[#0F172A]"><%= @closed_requests %></div>
                <div class="w-full bg-slate-200 h-1 rounded-full overflow-hidden">
                  <div class="bg-slate-500 h-full rounded-full" style={"width: #{(@closed_requests / @total_requests) * 100}%"}></div>
                </div>
              </.link>

            </div>
          </div>
          <!-- BOTTOM TWO PANELS GRID -->
          <div class="grid grid-cols-2 gap-5 shrink-0">

            <!-- RECENT ACTIVITY CARD -->
            <.link navigate={~p"/support/manager/activity"} class="block rounded-xl border border-[#E2E8F0] bg-white p-5 shadow-sm transition hover:border-[#CBD5E1] hover:shadow-md">

            <div class="bg-white rounded-2xl border border-[#E2E8F0] p-5 shadow-sm space-y-3">
              <div class="pb-2 border-b border-[#E2E8F0]">
                <h3 class="text-sm font-bold text-[#0F172A] tracking-tight">

                  Recent Activity
                </h3>
              </div>

              <div class="space-y-2">
                <%= for activity <- @recent_activities do %>
                <div class="flex items-center justify-between text-xs pb-1.5 border-b border-[#F1F5F9] last:border-0 last:pb-0">
                  <div class="flex items-center gap-2.5 truncate pr-2">
                    <div class="h-1.5 w-1.5 rounded-full bg-[#1D4ED8] shrink-0"></div>
                    <span class="font-medium text-[#0F172A] truncate">
                      <%= activity.description %>
                    </span>
                  </div>

                  <span class="font-mono text-[10px] text-[#94A3B8] shrink-0">
                    <%= Calendar.strftime(activity.inserted_at, "%d %b %H:%M") %>
                  </span>
                </div>
                <% end %>
              </div>
            </div>
            </.link>

            <!-- MANAGER INFO CARD -->
            <div class="bg-white rounded-2xl border border-[#E2E8F0] p-5 shadow-sm space-y-3">
              <div class="pb-2 border-b border-[#E2E8F0]">
                <h3 class="text-sm font-bold text-[#0F172A] tracking-tight">
                  Manager Info
                </h3>
              </div>

              <div class="space-y-2 text-xs">
                <div class="flex justify-between items-center px-3 py-1.5 rounded-lg bg-[#F8FAFC] border border-[#CBD5E1]/40">
                  <span class="font-mono text-[#64748B] uppercase text-[9px] font-bold">Name</span>
                  <span class="font-bold text-[#0F172A]"><%= @current_manager.name %></span>
                </div>

                <div class="flex justify-between items-center px-3 py-1.5 rounded-lg bg-[#F8FAFC] border border-[#CBD5E1]/40">
                  <span class="font-mono text-[#64748B] uppercase text-[9px] font-bold">Email</span>
                  <span class="font-mono font-semibold text-[#0F172A]"><%= @current_manager.email %></span>
                </div>

                <div class="flex justify-between items-center px-3 py-1.5 rounded-lg bg-[#F8FAFC] border border-[#CBD5E1]/40">
                  <span class="font-mono text-[#64748B] uppercase text-[9px] font-bold">Manager ID</span>
                  <code class="font-mono font-bold text-[#1D4ED8]">
                    <%= @current_manager.manager_identifier %>
                  </code>
                </div>
              </div>
            </div>

          </div>

        </div>

        <!-- FOOTER SIGN-OFF -->
        <footer class="px-8 py-2.5 text-center text-[10px] font-mono text-[#94A3B8] shrink-0 border-t border-[#E2E8F0]/60 bg-white">
          SUPPORTDESK SYSTEM • ALL RIGHTS RESERVED
        </footer>

      </main>

    </div>
    """
  end
end

defmodule CustomerSupportWeb.ActivityIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.ActivityLogs

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(_params, _session, socket) do
    activities = ActivityLogs.list_recent_activities(100)

    {:ok, assign(socket, :activities, activities)}
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
              class="block text-[#94A3B8] hover:text-white hover:bg-white/5 rounded-xl px-4 py-3 font-medium text-xs tracking-wider transition-all"
            >
              Dashboard
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

            <.link
              navigate={~p"/support/manager/activity"}
              class="flex items-center justify-between bg-[#1E40AF] text-white rounded-xl px-4 py-3 font-semibold text-xs uppercase tracking-wider shadow-md shadow-[#1E40AF]/20 transition-all"
            >
              <span>Activity Log</span>
              <div class="h-1.5 w-1.5 rounded-full bg-[#F59E0B]"></div>
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
              MANAGEMENT PORTAL / ACTIVITY LOG
            </span>
          </div>

          <div class="flex items-center gap-4">
            <.link
              navigate={~p"/support/manager/dashboard"}
              class="px-3.5 py-1.5 rounded-lg bg-[#F8FAFC] border border-[#CBD5E1] text-[#0F172A] hover:bg-[#0F172A] hover:text-white transition-all text-[11px] font-mono font-bold uppercase tracking-wider"
            >
              Back to Dashboard
            </.link>
          </div>
        </header>

        <!-- ACTIVITY LOG CONTENT CONTAINER -->
        <div class="flex-1 p-6 max-w-6xl w-full mx-auto flex flex-col min-h-0">

          <!-- PAGE HEADER -->
          <div class="shrink-0 mb-5 flex items-center justify-between">
            <div class="space-y-0.5">
              <h1 class="text-2xl font-black text-[#0F172A] tracking-tight">
                Activity Log
              </h1>
              <p class="text-[11px] text-[#64748B] font-light">
                Track recent actions and events across the support system.
              </p>
            </div>

            <div class="text-[10px] font-mono font-bold text-[#94A3B8] bg-white border border-[#E2E8F0] px-3 py-1.5 rounded-lg">
              SHOWING RECENT <%= length(@activities) %> EVENTS
            </div>
          </div>

          <!-- TABLE CONTAINER (SCROLLABLE INNER LIST) -->
          <div class="flex-1 overflow-hidden flex flex-col rounded-2xl border border-[#E2E8F0] bg-white shadow-sm">

            <!-- TABLE HEADER -->
            <div class="grid grid-cols-[160px_1fr_180px] border-b border-[#E2E8F0] bg-[#F8FAFC] px-5 py-3 text-[10px] font-mono font-bold uppercase tracking-widest text-[#64748B] shrink-0">
              <div>Action</div>
              <div>Activity</div>
              <div class="text-right">Date & Time</div>
            </div>

            <!-- TABLE BODY (SCROLLS INDEPENDENTLY IF LIST IS LONG) -->
            <div class="flex-1 overflow-y-auto divide-y divide-[#F1F5F9]">
              <%= for activity <- @activities do %>
                <div class="grid grid-cols-[160px_1fr_180px] items-center px-5 py-3.5 hover:bg-[#F8FAFC] transition-colors">

                  <!-- ACTION BADGE -->
                  <div>
                    <span class={[
                      "inline-flex rounded-md px-2.5 py-0.5 text-[10px] font-mono font-bold border uppercase tracking-wider",
                      case activity.action do
                        "request_assigned" ->
                          "bg-emerald-50 text-emerald-700 border-emerald-200"

                        "request_reassigned" ->
                          "bg-blue-50 text-blue-700 border-blue-200"

                        "request_unassigned" ->
                          "bg-amber-50 text-amber-700 border-amber-200"

                        "staff_created" ->
                          "bg-purple-50 text-purple-700 border-purple-200"

                        _ ->
                          "bg-slate-100 text-slate-700 border-slate-300"
                      end
                    ]}>
                      <%= activity.action |> String.replace("_", " ") %>
                    </span>
                  </div>

                  <!-- DESCRIPTION & ENTITY -->
                  <div class="pr-6">
                    <p class="text-xs font-semibold text-[#0F172A] leading-relaxed">
                      <%= activity.description %>
                    </p>

                    <%= if activity.entity_type do %>
                      <p class="mt-0.5 text-[10px] font-mono font-medium text-[#94A3B8] uppercase tracking-wider">
                        <%= activity.entity_type %>
                      </p>
                    <% end %>
                  </div>

                  <!-- DATE & TIME -->
                  <div class="text-right">
                    <p class="text-xs font-bold font-mono text-[#0F172A]">
                      <%= Calendar.strftime(activity.inserted_at, "%d %b %Y") %>
                    </p>
                    <p class="text-[10px] font-mono text-[#94A3B8]">
                      <%= Calendar.strftime(activity.inserted_at, "%H:%M") %>
                    </p>
                  </div>

                </div>
              <% end %>

              <!-- EMPTY STATE -->
              <%= if @activities == [] do %>
                <div class="px-6 py-12 text-center space-y-1">
                  <p class="text-xs font-bold text-[#0F172A]">
                    No activity recorded yet.
                  </p>
                  <p class="text-[11px] text-[#94A3B8]">
                    System activity logs will appear here automatically.
                  </p>
                </div>
              <% end %>
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

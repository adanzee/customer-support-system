defmodule CustomerSupportWeb.ActivityIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.ActivityLogs
  alias CustomerSupportWeb.ManagerLayout


  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(_params, _session, socket) do
    activities = ActivityLogs.list_recent_activities(100)

    {:ok, assign(socket, :activities, activities)}
  end

  def render(assigns) do
    ~H"""
    <ManagerLayout.manager_layout current_path={~p"/support/manager/activity"}>



      <!-- MAIN CONTENT AREA -->
      <main class="flex-1 h-full flex flex-col justify-between min-w-0 overflow-hidden">

        <!-- TOP BAR -->
        <header class="bg-white border-b border-[#E2E8F0] px-8 py-3.5 flex justify-between items-center shadow-sm shrink-0">
          <div class="flex items-center gap-3">
            <span class="text-[11px] font-mono font-bold tracking-widest text-[#475569] uppercase">
              MANAGEMENT PORTAL / ACTIVITY LOG
            </span>
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


    </ManagerLayout.manager_layout>
    """
  end
end

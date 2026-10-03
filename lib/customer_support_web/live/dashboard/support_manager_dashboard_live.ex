defmodule CustomerSupportWeb.SupportManagerDashboardLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.ActivityLogs
  alias CustomerSupport.Requests
  alias CustomerSupport.SupportStaff
  alias CustomerSupportWeb.ManagerLayout

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
  <ManagerLayout.manager_layout current_path={~p"/support/manager/dashboard"}>

  <!-- MAIN WRAPPER -->
  <div class="flex-1 flex flex-col min-w-0">
    <!-- TOP HEADER BAR -->
    <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/90 backdrop-blur-md px-8 py-4 flex items-center justify-between">
      <div>
        <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-slate-400">
          Management Portal
        </p>
        <h1 class="text-base font-bold text-slate-900">
          Overview
        </h1>
      </div>

      <div class="flex items-center gap-6">
        <div class="text-right">
          <p class="font-bold text-xs text-slate-900">
            <%= @current_manager.name %>
          </p>
          <p class="text-[10px] text-slate-500 font-mono">
            <%= @current_manager.email %>
          </p>
        </div>

        <div class="h-6 w-px bg-slate-200"></div>

        <.link
          href={~p"/support/logout"}
          method="post"
          class="px-3.5 py-1.5 rounded-lg border border-slate-200 bg-white text-xs font-semibold text-slate-700 shadow-sm hover:bg-slate-50 transition"
        >
          LOGOUT
        </.link>
      </div>
    </header>

    <!-- DASHBOARD CONTENT CONTAINER -->
    <main class="flex-1 px-8 py-8 overflow-y-auto space-y-8 max-w-7xl w-full mx-auto">

      <!-- WELCOME HEADER -->
      <div>
        <h1 class="text-2xl font-black tracking-tight text-slate-900">
          Welcome back, <%= @current_manager.name %>
        </h1>
        <p class="mt-1 text-xs text-slate-500">
          Here is an overview of your support system activity and status metrics.
        </p>
      </div>

      <!-- TOP 3 STAT CARDS -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- TOTAL REQUESTS CARD -->
        <.link
          navigate={~p"/support/manager/requests"}
          class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm flex flex-col justify-between hover:border-blue-600 hover:shadow-md transition group"
        >
          <div class="flex items-center justify-between">
            <span class="text-xs font-mono font-bold uppercase tracking-wider text-slate-500 group-hover:text-blue-600 transition-colors">
              Requests
            </span>
            <span class="h-2.5 w-2.5 rounded-full bg-blue-600"></span>
          </div>
          <div class="mt-4 text-3xl font-black text-slate-900">
            <%= @total_requests %>
          </div>
        </.link>

        <!-- OPEN REQUESTS CARD -->
        <.link
          navigate={~p"/support/manager/requests?status=open"}
          class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm flex flex-col justify-between hover:border-amber-500 hover:shadow-md transition group"
        >
          <div class="flex items-center justify-between">
            <span class="text-xs font-mono font-bold uppercase tracking-wider text-slate-500 group-hover:text-amber-500 transition-colors">
              Open
            </span>
            <span class="h-2.5 w-2.5 rounded-full bg-amber-500"></span>
          </div>
          <div class="mt-4 text-3xl font-black text-slate-900">
            <%= @open_requests %>
          </div>
        </.link>

        <!-- STAFF CARD -->
        <.link
          navigate={~p"/support/manager/staff"}
          class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm flex flex-col justify-between hover:border-emerald-500 hover:shadow-md transition group"
        >
          <div class="flex items-center justify-between">
            <span class="text-xs font-mono font-bold uppercase tracking-wider text-slate-500 group-hover:text-emerald-600 transition-colors">
              Staff
            </span>
            <span class="h-2.5 w-2.5 rounded-full bg-emerald-500"></span>
          </div>
          <div class="mt-4 text-3xl font-black text-slate-900">
            <%= @total_staff %>
          </div>
        </.link>
      </div>

      <!-- REQUEST OVERVIEW PANEL -->
      <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-slate-200">
          <div class="flex items-center gap-2">
            <span class="h-2 w-2 rounded-full bg-blue-600"></span>
            <h3 class="text-sm font-bold text-slate-900">
              Request Overview
            </h3>
          </div>
          <span class="text-[10px] font-mono text-slate-400 uppercase tracking-wider">
            TOTAL: <%= @total_requests %> REQUESTS
          </span>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
          <!-- OPEN STATUS -->
          <.link
            navigate={~p"/support/manager/requests?status=open"}
            class="bg-slate-50 p-4 rounded-xl border border-amber-200/80 space-y-2 hover:border-amber-400 hover:bg-amber-50/40 transition block group"
          >
            <div class="flex items-center justify-between">
              <span class="text-xs font-semibold text-slate-600 group-hover:text-amber-800 transition-colors">
                Open
              </span>
              <span class="h-1.5 w-1.5 rounded-full bg-amber-500"></span>
            </div>
            <div class="text-2xl font-black text-slate-900">
              <%= @open_requests %>
            </div>
            <div class="w-full bg-amber-100 h-1.5 rounded-full overflow-hidden">
              <div
                class="bg-amber-500 h-full rounded-full transition-all duration-300"
                style={"width: #{if @total_requests > 0, do: (@open_requests / @total_requests) * 100, else: 0}%"}
              ></div>
            </div>
          </.link>

          <!-- IN PROGRESS STATUS -->
          <.link
            navigate={~p"/support/manager/requests?status=in_progress"}
            class="bg-slate-50 p-4 rounded-xl border border-blue-200/80 space-y-2 hover:border-blue-400 hover:bg-blue-50/40 transition block group"
          >
            <div class="flex items-center justify-between">
              <span class="text-xs font-semibold text-slate-600 group-hover:text-blue-800 transition-colors">
                In Progress
              </span>
              <span class="h-1.5 w-1.5 rounded-full bg-blue-500"></span>
            </div>
            <div class="text-2xl font-black text-slate-900">
              <%= @in_progress_requests %>
            </div>
            <div class="w-full bg-blue-100 h-1.5 rounded-full overflow-hidden">
              <div
                class="bg-blue-500 h-full rounded-full transition-all duration-300"
                style={"width: #{if @total_requests > 0, do: (@in_progress_requests / @total_requests) * 100, else: 0}%"}
              ></div>
            </div>
          </.link>

          <!-- WAITING STATUS -->
          <.link
            navigate={~p"/support/manager/requests?status=waiting"}
            class="bg-slate-50 p-4 rounded-xl border border-purple-200/80 space-y-2 hover:border-purple-400 hover:bg-purple-50/40 transition block group"
          >
            <div class="flex items-center justify-between">
              <span class="text-xs font-semibold text-slate-600 group-hover:text-purple-800 transition-colors">
                Waiting
              </span>
              <span class="h-1.5 w-1.5 rounded-full bg-purple-500"></span>
            </div>
            <div class="text-2xl font-black text-slate-900">
              <%= @waiting_requests %>
            </div>
            <div class="w-full bg-purple-100 h-1.5 rounded-full overflow-hidden">
              <div
                class="bg-purple-500 h-full rounded-full transition-all duration-300"
                style={"width: #{if @total_requests > 0, do: (@waiting_requests / @total_requests) * 100, else: 0}%"}
              ></div>
            </div>
          </.link>

          <!-- RESOLVED STATUS -->
          <.link
            navigate={~p"/support/manager/requests?status=resolved"}
            class="bg-slate-50 p-4 rounded-xl border border-emerald-200/80 space-y-2 hover:border-emerald-400 hover:bg-emerald-50/40 transition block group"
          >
            <div class="flex items-center justify-between">
              <span class="text-xs font-semibold text-slate-600 group-hover:text-emerald-800 transition-colors">
                Resolved
              </span>
              <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-2xl font-black text-slate-900">
              <%= @resolved_requests %>
            </div>
            <div class="w-full bg-emerald-100 h-1.5 rounded-full overflow-hidden">
              <div
                class="bg-emerald-500 h-full rounded-full transition-all duration-300"
                style={"width: #{if @total_requests > 0, do: (@resolved_requests / @total_requests) * 100, else: 0}%"}
              ></div>
            </div>
          </.link>

          <!-- CLOSED STATUS -->
          <.link
            navigate={~p"/support/manager/requests?status=closed"}
            class="bg-slate-50 p-4 rounded-xl border border-slate-200 space-y-2 hover:border-slate-400 hover:bg-slate-100/60 transition block group"
          >
            <div class="flex items-center justify-between">
              <span class="text-xs font-semibold text-slate-600 group-hover:text-slate-800 transition-colors">
                Closed
              </span>
              <span class="h-1.5 w-1.5 rounded-full bg-slate-400"></span>
            </div>
            <div class="text-2xl font-black text-slate-900">
              <%= @closed_requests %>
            </div>
            <div class="w-full bg-slate-200 h-1.5 rounded-full overflow-hidden">
              <div
                class="bg-slate-500 h-full rounded-full transition-all duration-300"
                style={"width: #{if @total_requests > 0, do: (@closed_requests / @total_requests) * 100, else: 0}%"}
              ></div>
            </div>
          </.link>
        </div>
      </div>

      <!-- BOTTOM PANELS GRID -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- RECENT ACTIVITY CARD -->
        <.link
          navigate={~p"/support/manager/activity"}
          class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm hover:border-slate-300 transition flex flex-col justify-between"
        >
          <div>
            <div class="pb-3 border-b border-slate-200 mb-4">
              <h3 class="text-sm font-bold text-slate-900">
                Recent Activity
              </h3>
            </div>

            <div class="space-y-3">
              <%= for activity <- @recent_activities do %>
                <div class="flex items-center justify-between text-xs pb-2 border-b border-slate-100 last:border-0 last:pb-0">
                  <div class="flex items-center gap-3 truncate pr-2">
                    <span class="h-2 w-2 rounded-full bg-blue-600 shrink-0"></span>
                    <span class="font-medium text-slate-800 truncate">
                      <%= activity.description %>
                    </span>
                  </div>
                  <span class="font-mono text-[10px] text-slate-400 shrink-0">
                    <%= Calendar.strftime(activity.inserted_at, "%d %b %H:%M") %>
                  </span>
                </div>
              <% end %>
            </div>
          </div>
        </.link>

        <!-- MANAGER INFO CARD -->
        <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm">
          <div class="pb-3 border-b border-slate-200 mb-4">
            <h3 class="text-sm font-bold text-slate-900">
              Manager Info
            </h3>
          </div>

          <div class="space-y-2.5 text-xs">
            <div class="flex justify-between items-center p-3 rounded-xl bg-slate-50 border border-slate-100">
              <span class="font-mono text-slate-500 uppercase text-[10px] font-bold">
                Name
              </span>
              <span class="font-bold text-slate-900">
                <%= @current_manager.name %>
              </span>
            </div>

            <div class="flex justify-between items-center p-3 rounded-xl bg-slate-50 border border-slate-100">
              <span class="font-mono text-slate-500 uppercase text-[10px] font-bold">
                Email
              </span>
              <span class="font-mono font-semibold text-slate-800">
                <%= @current_manager.email %>
              </span>
            </div>

            <div class="flex justify-between items-center p-3 rounded-xl bg-slate-50 border border-slate-100">
              <span class="font-mono text-slate-500 uppercase text-[10px] font-bold">
                Manager ID
              </span>
              <code class="font-mono font-bold text-blue-600 bg-blue-50 px-2 py-0.5 rounded">
                <%= @current_manager.manager_identifier %>
              </code>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- FOOTER -->
    <footer class="px-8 py-4 text-center text-[10px] font-mono text-slate-400 border-t border-slate-200/80 bg-white shrink-0">
      SUPPORTDESK SYSTEM • ALL RIGHTS RESERVED
    </footer>
  </div>


  </ManagerLayout.manager_layout>
  """
end
end

defmodule CustomerSupportWeb.ManagerSidebar do
  use CustomerSupportWeb, :html

  attr :current_path, :string, required: true

  def sidebar(assigns) do
    ~H"""
    <aside class="flex w-64 shrink-0 flex-col justify-between bg-[#0F172A] p-6 text-white">
      <div>
        <!-- BRAND -->
        <div class="mb-8 flex items-center gap-3 border-b border-slate-800 pb-8">
          <div class="h-3 w-3 rounded-full bg-amber-500"></div>

          <span class="text-sm font-bold uppercase tracking-widest">
            SUPPORTDESK
          </span>
        </div>

        <!-- NAVIGATION -->
        <nav class="space-y-2">

          <.link
            navigate={~p"/support/manager/dashboard"}
            class={nav_class(@current_path, "/support/manager/dashboard")}
          >
            Dashboard
          </.link>

          <.link
            navigate={~p"/support/manager/requests"}
            class={nav_class(@current_path, "/support/manager/requests")}
          >
            Requests
          </.link>

          <.link
            navigate={~p"/support/manager/staff"}
            class={nav_class(@current_path, "/support/manager/staff")}
          >
            Staff Management
          </.link>

          <.link
            navigate={~p"/support/manager/activity"}
            class={nav_class(@current_path, "/support/manager/activity")}
          >
            Activity
          </.link>

        </nav>
      </div>

      <!-- SIDEBAR FOOTER -->
      <div class="flex items-center justify-between border-t border-slate-800 pt-6 text-[10px] text-slate-500">
        <span>MANAGER PORTAL</span>
        <span class="h-2 w-2 rotate-45 bg-amber-500"></span>
      </div>
    </aside>
    """
  end

  defp nav_class(current_path, path) do
    if current_path == path do
      "flex items-center justify-between rounded-xl bg-blue-600 px-4 py-3 text-xs font-semibold text-white shadow-sm"
    else
      "flex items-center gap-3 rounded-xl px-4 py-3 text-xs font-semibold text-slate-400 transition hover:bg-slate-800/50 hover:text-white"
    end
  end
end

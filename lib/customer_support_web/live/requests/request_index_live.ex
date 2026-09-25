defmodule CustomerSupportWeb.RequestIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests

  def mount(_params, session, socket) do
    customer_id = session["customer_id"]

    requests = Requests.list_requests_by_customer(customer_id)

    {:ok, assign(socket, :requests, requests)}
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-6xl mx-auto space-y-8 py-4 font-sans">

      <!-- PAGE HEADER BANNER -->
      <div class="relative overflow-hidden rounded-3xl bg-[#112250] p-8 md:p-10 text-[#F5F0E9] shadow-xl">
        <!-- Background Glow Effects -->
        <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
        <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

        <div class="relative z-10 flex flex-col sm:flex-row sm:items-center justify-between gap-6">
          <div>
            <!-- TOP NAVIGATION BAR (DASHBOARD ACCESS) -->
            <div class="flex items-center gap-4 mb-3">
              <.link
                navigate={~p"/dashboard"}
                class="inline-flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-[#E0C58F] hover:text-[#F5F0E9] transition-colors"
              >
                <.icon name="hero-arrow-left" class="size-4" />
                Dashboard
              </.link>

              <span class="text-[#3C5070] text-xs">•</span>

              <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-[#3C5070]/40 border border-[#E0C58F]/20 text-[11px] font-bold uppercase tracking-widest text-[#E0C58F]">
                <span class="w-1.5 h-1.5 rounded-full bg-[#E0C58F]"></span>
                Support Desk
              </span>
            </div>

            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tight text-[#F5F0E9]">
              My Requests
            </h1>
            <p class="mt-2 text-[#D9CBC2] text-sm md:text-base">
              View, monitor, and track the progress of all your submitted tickets.
            </p>
          </div>

          <!-- NEW REQUEST ACTION BUTTON -->
          <div class="self-start sm:self-auto">
            <.link
              navigate={~p"/requests/new"}
              class="inline-flex items-center gap-2 rounded-xl bg-[#E0C58F] px-5 py-3 font-bold text-sm text-[#112250] shadow-md hover:bg-[#D9CBC2] active:scale-[0.98] transition-all duration-200"
            >
              <.icon name="hero-plus" class="size-5 stroke-[2.5]" />
              New Request
            </.link>
          </div>
        </div>
      </div>

      <!-- REQUESTS TABLE CARD -->
      <div class="rounded-3xl border border-[#D9CBC2]/60 bg-white shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="border-b border-[#D9CBC2]/40 bg-[#F5F0E9]/40 text-[11px] font-bold uppercase tracking-wider text-[#3C5070]">
                <th class="py-4 px-6">Request ID</th>
                <th class="py-4 px-6">Title</th>
                <th class="py-4 px-6">Category</th>
                <th class="py-4 px-6">Status</th>
                <th class="py-4 px-6">Priority</th>
                <th class="py-4 px-6 text-right">Created</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-[#D9CBC2]/30 text-sm font-medium text-[#112250]">
              <%= for request <- @requests do %>
                <tr class="hover:bg-[#F5F0E9]/30 transition-colors cursor-pointer group">

                  <!-- REQUEST ID WITH LINK -->
                    <td class="py-4 px-6">
                      <.link
                        navigate={~p"/requests/#{request.request_id}"}
                        class="inline-block"
                      >
                        <code class="px-2.5 py-1 rounded-lg bg-[#F5F0E9] border border-[#D9CBC2]/60 font-mono text-xs text-[#3C5070] group-hover:border-[#112250] transition-colors">
                          # <%= String.slice(to_string(request.request_id || request.id), 0..7) %>...
                        </code>
                      </.link>
                    </td>

                    <!-- TITLE -->
                    <td class="py-4 px-6">
                      <.link
                        navigate={~p"/requests/#{request.request_id}"}
                        class="font-bold text-[#112250] group-hover:text-[#3C5070] transition-colors"
                      >
                        <%= request.title %>
                      </.link>
                    </td>

                  <!-- CATEGORY -->
                  <td class="py-4 px-6 text-[#3C5070]">
                    <%= request.category %>
                  </td>

                  <!-- STATUS BADGE -->
                  <td class="py-4 px-6">
                    <%
                      status_str = String.downcase(to_string(request.status))
                      {bg_cls, text_cls, dot_cls} = case status_str do
                        "open" -> {"bg-emerald-50 border-emerald-200", "text-emerald-800", "bg-emerald-500"}
                        "in_progress" -> {"bg-blue-50 border-blue-200", "text-blue-800", "bg-blue-500"}
                        "resolved" -> {"bg-gray-100 border-gray-200", "text-gray-700", "bg-gray-400"}
                        _ -> {"bg-[#F5F0E9] border-[#D9CBC2]", "text-[#112250]", "bg-[#3C5070]"}
                      end
                    %>
                    <span class={"inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold border #{bg_cls} #{text_cls}"}>
                      <span class={"w-1.5 h-1.5 rounded-full #{dot_cls}"}></span>
                      <%= Phoenix.Naming.humanize(request.status) %>
                    </span>
                  </td>

                  <!-- PRIORITY BADGE -->
                  <td class="py-4 px-6">
                    <%
                      priority_str = String.downcase(to_string(request.priority))
                      priority_bg = case priority_str do
                        "high" -> "bg-amber-100 text-amber-900 border-amber-300"
                        "urgent" -> "bg-rose-100 text-rose-900 border-rose-300"
                        "medium" -> "bg-[#E0C58F]/40 text-[#112250] border-[#E0C58F]"
                        _ -> "bg-[#F5F0E9] text-[#3C5070] border-[#D9CBC2]"
                      end
                    %>
                    <span class={"inline-flex px-3 py-1 rounded-full text-xs font-semibold border #{priority_bg}"}>
                      <%= Phoenix.Naming.humanize(request.priority) %>
                    </span>
                  </td>

                  <!-- CREATED DATE -->
                  <td class="py-4 px-6 text-right text-[#3C5070] text-xs">
                    <%= Calendar.strftime(request.inserted_at, "%b %d, %Y") %>
                  </td>

                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>

    </div>
    """
  end
end

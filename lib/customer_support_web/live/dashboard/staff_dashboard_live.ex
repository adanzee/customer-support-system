defmodule CustomerSupportWeb.StaffDashboardLive do
  use CustomerSupportWeb, :live_view

  on_mount {CustomerSupportWeb.StaffAuthHook, :default}

  def mount(_params, _session, socket) do
    requests =
      CustomerSupport.SupportStaff.list_assigned_requests(
        socket.assigns.current_staff.staff_id
      )

    {:ok, assign(socket, :requests, requests)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-dvh w-full bg-[#F5F0E9] text-[#112250] font-sans selection:bg-[#E0C58F] selection:text-[#112250]">

      <!-- TOP BRAND NAVIGATION HEADER -->
      <header class="bg-[#112250] border-b border-[#3C5070]/40 text-[#F5F0E9] shadow-md">
        <div class="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">

          <div class="flex items-center gap-3">
            <div class="h-2.5 w-2.5 rounded-full bg-[#E0C58F] ring-4 ring-[#E0C58F]/20"></div>
            <div>
              <h1 class="text-base font-bold tracking-tight text-[#F5F0E9]">
                Support Staff Dashboard
              </h1>
              <p class="text-[11px] font-mono text-[#D9CBC2]/80 uppercase tracking-wider">
                SupportDesk Internal Portal
              </p>
            </div>
          </div>

          <div class="flex items-center gap-6">

            <div class="text-right hidden sm:block">
              <p class="text-xs font-bold text-[#F5F0E9]">
                <%= @current_staff.name %>
              </p>
              <p class="text-[11px] font-mono text-[#E0C58F]">
                <%= @current_staff.email %>
              </p>
            </div>

            <form action="/support/staff/logout" method="post">
              <input
                type="hidden"
                name="_csrf_token"
                value={Plug.CSRFProtection.get_csrf_token()}
              />

              <button
                type="submit"
                class="rounded-xl border border-[#3C5070] bg-[#3C5070]/30 px-3.5 py-1.5 text-xs font-mono font-bold uppercase tracking-wider text-[#F5F0E9] transition hover:bg-[#E0C58F] hover:text-[#112250] hover:border-[#E0C58F]"
              >
                Logout
              </button>
            </form>

          </div>
        </div>
      </header>

      <!-- MAIN CONTENT -->
      <main class="mx-auto max-w-7xl px-6 py-8 space-y-8">

        <!-- WELCOME BANNER -->
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 border-b border-[#D9CBC2] pb-6">
          <div>
            <h2 class="text-2xl font-black text-[#112250] tracking-tight">
              Welcome back, <%= @current_staff.name %>
            </h2>
            <p class="mt-1 text-xs text-[#3C5070] font-medium">
              Review and manage your assigned support request queues below.
            </p>
          </div>

          <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-xl bg-white border border-[#D9CBC2] shadow-sm w-fit">
            <span class="text-[11px] font-mono font-bold uppercase tracking-wider text-[#3C5070]">
              Staff ID:
            </span>
            <span class="text-[11px] font-mono font-bold text-[#112250]">
              <%= @current_staff.staff_identifier %>
            </span>
          </div>
        </div>

        <!-- STATS CARDS -->
        <div class="grid grid-cols-1 gap-5 sm:grid-cols-3">

          <!-- Stat 1 -->
          <div class="rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm relative overflow-hidden group hover:border-[#112250] transition-colors">
            <div class="absolute top-0 left-0 w-1.5 h-full bg-[#112250]"></div>
            <p class="text-[11px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
              Assigned Requests
            </p>
            <p class="mt-3 text-3xl font-black text-[#112250]">
              <%= length(@requests) %>
            </p>
          </div>

          <!-- Stat 2 -->
          <div class="rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm relative overflow-hidden group hover:border-[#3C5070] transition-colors">
            <div class="absolute top-0 left-0 w-1.5 h-full bg-[#3C5070]"></div>
            <p class="text-[11px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
              In Progress
            </p>
            <p class="mt-3 text-3xl font-black text-[#112250]">
              <%= Enum.count(@requests, fn request -> request.status == "In Progress" end) %>
            </p>
          </div>

          <!-- Stat 3 -->
          <div class="rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm relative overflow-hidden group hover:border-[#E0C58F] transition-colors">
            <div class="absolute top-0 left-0 w-1.5 h-full bg-[#E0C58F]"></div>
            <p class="text-[11px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
              Waiting for Customer
            </p>
            <p class="mt-3 text-3xl font-black text-[#112250]">
              <%= Enum.count(@requests, fn request -> request.status == "Waiting for Customer" end) %>
            </p>
          </div>

        </div>

        <!-- REQUESTS TABLE / EMPTY STATE -->
        <div class="overflow-hidden rounded-2xl border border-[#D9CBC2] bg-white shadow-xl shadow-[#112250]/5">

          <!-- Card Header -->
          <div class="border-b border-[#D9CBC2] bg-[#F5F0E9]/60 px-6 py-4 flex items-center justify-between">
            <div>
              <h3 class="text-sm font-bold text-[#112250] uppercase font-mono tracking-wider">
                Assigned Queue
              </h3>
              <p class="mt-0.5 text-xs text-[#3C5070]">
                Active tickets assigned by your support administrator.
              </p>
            </div>
            <span class="px-2.5 py-1 rounded-full text-[10px] font-mono font-bold uppercase bg-[#112250] text-[#E0C58F]">
              <%= length(@requests) %> Active
            </span>
          </div>

          <%= if @requests == [] do %>

            <!-- Empty State -->
            <div class="px-6 py-16 text-center bg-white">
              <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-[#F5F0E9] border border-[#D9CBC2]">
                <span class="text-xl text-[#112250] font-bold">✓</span>
              </div>

              <h4 class="mt-4 text-sm font-bold text-[#112250]">
                Queue Cleared
              </h4>

              <p class="mt-1 text-xs text-[#3C5070]">
                There are no open requests assigned to your account right now.
              </p>
            </div>

          <% else %>

            <!-- Data Table -->
            <div class="overflow-x-auto">
              <table class="w-full text-left border-collapse">
                <thead>
                  <tr class="border-b border-[#D9CBC2] bg-[#112250] text-[#F5F0E9]">
                    <th class="px-6 py-3.5 text-[10px] font-mono font-bold uppercase tracking-widest">
                      Request Title
                    </th>
                    <th class="px-6 py-3.5 text-[10px] font-mono font-bold uppercase tracking-widest">
                      Customer
                    </th>
                    <th class="px-6 py-3.5 text-[10px] font-mono font-bold uppercase tracking-widest">
                      Category
                    </th>
                    <th class="px-6 py-3.5 text-[10px] font-mono font-bold uppercase tracking-widest">
                      Status
                    </th>
                    <th class="px-6 py-3.5 text-[10px] font-mono font-bold uppercase tracking-widest">
                      Priority
                    </th>
                    <th class="px-6 py-3.5"></th>
                  </tr>
                </thead>

                <tbody class="divide-y divide-[#D9CBC2]/60 bg-white">
                  <%= for request <- @requests do %>
                    <tr class="transition hover:bg-[#F5F0E9]/50 group">

                      <!-- Title & ID -->
                      <td class="px-6 py-4">
                        <.link
                          navigate={~p"/support/staff/requests/#{request.request_id}"}
                          class="block"
                        >
                          <p class="text-xs font-bold text-[#112250] group-hover:text-[#3C5070] transition-colors">
                            <%= request.title %>
                          </p>
                          <p class="mt-0.5 font-mono text-[10px] text-[#3C5070]/70">
                            #<%= request.request_id %>
                          </p>
                        </.link>
                      </td>

                      <!-- Customer -->
                      <td class="px-6 py-4 text-xs font-medium text-[#3C5070]">
                        <%= request.customer.name %>
                      </td>

                      <!-- Category -->
                      <td class="px-6 py-4">
                        <span class="rounded-lg bg-[#F5F0E9] border border-[#D9CBC2] px-2.5 py-1 text-[11px] font-mono font-medium text-[#112250]">
                          <%= request.category %>
                        </span>
                      </td>

                      <!-- Status Badge -->
                      <td class="px-6 py-4">
                        <span class={[
                          "inline-flex rounded-full px-2.5 py-1 text-[10px] font-mono font-bold border uppercase tracking-wider",
                          case request.status do
                            "Open" -> "bg-[#112250] text-[#F5F0E9] border-[#112250]"
                            "In Progress" -> "bg-[#3C5070] text-[#F5F0E9] border-[#3C5070]"
                            "Waiting for Customer" -> "bg-[#E0C58F]/30 text-[#112250] border-[#E0C58F]"
                            "Resolved" -> "bg-[#D9CBC2]/40 text-[#112250] border-[#D9CBC2]"
                            "Closed" -> "bg-[#F5F0E9] text-[#3C5070] border-[#D9CBC2]"
                            _ -> "bg-[#F5F0E9] text-[#3C5070] border-[#D9CBC2]"
                          end
                        ]}>
                          <%= request.status %>
                        </span>
                      </td>

                      <!-- Priority -->
                      <td class="px-6 py-4">
                        <span class={[
                          "text-xs font-bold uppercase font-mono tracking-wider",
                          case request.priority do
                            "Critical" -> "text-[#112250] underline decoration-[#E0C58F] decoration-2"
                            "High" -> "text-[#112250]"
                            "Medium" -> "text-[#3C5070]"
                            _ -> "text-[#3C5070]/70"
                          end
                        ]}>
                          <%= request.priority %>
                        </span>
                      </td>

                      <!-- Action link -->
                      <td class="px-6 py-4 text-right">
                        <.link
                          navigate={~p"/support/staff/requests/#{request.request_id}"}
                          class="inline-flex items-center gap-1 text-xs font-mono font-bold text-[#112250] hover:text-[#3C5070] group-hover:translate-x-0.5 transition-all"
                        >
                          <span>Manage</span>
                          <span class="text-[#E0C58F]">→</span>
                        </.link>
                      </td>

                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>

          <% end %>

        </div>

        <!-- STAFF INFORMATION PANEL -->
        <div class="rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm">
          <h3 class="text-xs font-mono font-bold uppercase tracking-wider text-[#112250]">
            Staff Profile Details
          </h3>

          <div class="mt-4 grid grid-cols-1 gap-6 sm:grid-cols-3 pt-4 border-t border-[#D9CBC2]/50">

            <div>
              <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                Full Name
              </p>
              <p class="mt-1 text-xs font-bold text-[#112250]">
                <%= @current_staff.name %>
              </p>
            </div>

            <div>
              <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                Email Address
              </p>
              <p class="mt-1 text-xs font-mono font-medium text-[#112250]">
                <%= @current_staff.email %>
              </p>
            </div>

            <div>
              <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                Identifier
              </p>
              <p class="mt-1 text-xs font-mono font-bold text-[#112250]">
                <%= @current_staff.staff_identifier %>
              </p>
            </div>

          </div>
        </div>

      </main>
    </div>
    """
  end
end

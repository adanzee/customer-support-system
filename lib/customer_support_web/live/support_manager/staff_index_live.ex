defmodule CustomerSupportWeb.StaffIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(_params, _session, socket) do
    staff = SupportStaff.list_staff()

    {:ok, assign(socket, :staff, staff)}
  end

  def handle_event("delete_staff", %{"id" => staff_id}, socket) do
    case SupportStaff.get_staff(staff_id) do
      nil ->
        {:noreply,
         put_flash(socket, :error, "Support staff not found.")}

      staff ->
        case SupportStaff.delete_staff(staff) do
          {:ok, _staff} ->
            {:noreply,
             socket
             |> assign(:staff, SupportStaff.list_staff())
             |> put_flash(:info, "Support staff deleted successfully.")}

          {:error, _changeset} ->
            {:noreply,
             put_flash(socket, :error, "Unable to delete support staff.")}
        end
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen bg-[#F8FAFC] text-[#0F172A] antialiased">
      <!-- LEFT SIDEBAR -->
      <aside class="w-64 shrink-0 bg-[#0F172A] text-white flex flex-col justify-between p-6">
        <div>
          <!-- BRAND / LOGO HEADER -->
          <div class="flex items-center gap-3 pb-8 mb-6 border-b border-slate-800">
            <div class="h-3 w-3 rounded-full bg-amber-500"></div>
            <span class="font-bold text-sm tracking-widest uppercase text-white">SUPPORTDESK</span>
          </div>

          <!-- NAVIGATION LINKS -->
          <nav class="space-y-2">
            <.link
              navigate={~p"/support/manager/dashboard"}
              class="flex items-center gap-3 px-4 py-3 rounded-xl text-xs font-semibold text-slate-400 hover:text-white hover:bg-slate-800/50 transition"
            >
              <span>Dashboard</span>
            </.link>

            <.link
              navigate={~p"/support/manager/requests"}
              class="flex items-center gap-3 px-4 py-3 rounded-xl text-xs font-semibold text-slate-400 hover:text-white hover:bg-slate-800/50 transition"
            >
              <span>Requests</span>
            </.link>

            <.link
              navigate={~p"/support/manager/staff"}
              class="flex items-center justify-between px-4 py-3 rounded-xl text-xs font-semibold text-white bg-blue-600 shadow-sm"
            >
              <span>Staff Management</span>
              <span class="h-2 w-2 rounded-full bg-amber-400"></span>
            </.link>
          </nav>
        </div>

        <!-- SIDEBAR FOOTER -->
        <div class="pt-6 border-t border-slate-800 text-[10px] text-slate-500 flex items-center justify-between">
          <span>GATEWAY v2.4</span>
          <span class="h-2 w-2 bg-amber-500 transform rotate-45"></span>
        </div>
      </aside>

      <!-- MAIN CONTENT WRAPPER -->
      <div class="flex-1 flex flex-col min-w-0">
        <!-- TOP NAVIGATION HEADER -->
        <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/90 backdrop-blur-md px-8 py-4 flex items-center justify-between">
          <div>
            <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
              Customer Support
            </p>
            <h1 class="text-lg font-bold text-slate-900">
              Staff Management
            </h1>
          </div>

          <div class="flex items-center gap-3">
            <.link
              navigate={~p"/support/manager/dashboard"}
              class="rounded-lg border border-slate-200 bg-white px-3.5 py-2 text-xs font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50"
            >
              Dashboard
            </.link>

            <.link
              navigate={~p"/support/manager/staff/new"}
              class="rounded-lg bg-[#0F172A] px-3.5 py-2 text-xs font-semibold text-white shadow-sm transition hover:bg-slate-800"
            >
              + Add Staff
            </.link>

            <%= if assigns[:current_manager] do %>
              <div class="h-6 w-px bg-slate-200 mx-1"></div>
              <.link
                href={~p"/support/logout"}
                method="post"
                class="rounded-lg border border-slate-200 bg-white px-3 py-2 text-xs font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50"
              >
                LOGOUT
              </.link>
            <% end %>
          </div>
        </header>

        <!-- MAIN PAGE CONTENT -->
        <main class="flex-1 px-8 py-8 overflow-y-auto">
          <!-- FLASH MESSAGES -->
          <div class="mb-6">
            <.flash kind={:info} flash={@flash} />
            <.flash kind={:error} flash={@flash} />
          </div>

          <!-- PAGE HEADER & TOTAL METRIC -->
          <div class="mb-8 flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
            <div>
              <p class="text-xs font-bold uppercase tracking-wider text-slate-500">
                Team
              </p>

              <h2 class="mt-1 text-3xl font-extrabold tracking-tight text-slate-900">
                Support Staff
              </h2>

              <p class="mt-1 max-w-2xl text-sm leading-6 text-slate-500">
                Manage your support team, update staff information, and remove staff accounts when necessary.
              </p>
            </div>

            <div class="rounded-xl border border-slate-200 bg-white px-5 py-3.5 shadow-sm min-w-[130px]">
              <p class="text-[11px] font-bold uppercase tracking-wider text-slate-500">
                Total Staff
              </p>

              <p class="mt-0.5 text-2xl font-black text-slate-900">
                <%= length(@staff) %>
              </p>
            </div>
          </div>

          <!-- STAFF TABLE -->
          <%= if @staff == [] do %>
            <div class="rounded-2xl border border-slate-200 bg-white px-6 py-16 text-center shadow-sm">
              <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-slate-100 text-slate-500">
                <svg
                  class="h-7 w-7"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="1.7"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M16 21v-2a4 4 0 00-4-4H6a4 4 0 00-4 4v2m8-8a4 4 0 100-8 4 4 0 000 8zm6-3a3 3 0 100-6m4 17v-2a4 4 0 00-3-3.87"
                  />
                </svg>
              </div>

              <h3 class="mt-5 text-lg font-bold text-slate-900">
                No support staff yet
              </h3>

              <p class="mx-auto mt-1 max-w-md text-xs text-slate-500">
                Create your first support staff account to start assigning customer requests.
              </p>

              <.link
                navigate={~p"/support/manager/staff/new"}
                class="mt-6 inline-flex items-center rounded-lg bg-[#0F172A] px-4 py-2.5 text-xs font-bold text-white shadow-sm transition hover:bg-slate-800"
              >
                Create Support Staff
              </.link>
            </div>
          <% else %>
            <div class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
              <!-- TABLE HEADER -->
              <div class="flex flex-col justify-between gap-3 border-b border-slate-200 px-6 py-4 sm:flex-row sm:items-center bg-slate-50">
                <div>
                  <h3 class="text-sm font-bold text-slate-900">
                    Team Members
                  </h3>

                  <p class="mt-0.5 text-xs text-slate-500">
                    Staff accounts currently registered in the system.
                  </p>
                </div>

                <span class="inline-flex w-fit rounded-full bg-white border border-slate-200 px-3 py-1 text-xs font-bold text-slate-700 shadow-sm">
                  <%= length(@staff) %> members
                </span>
              </div>

              <!-- TABLE -->
              <div class="overflow-x-auto">
                <table class="min-w-full text-left">
                  <thead class="border-b border-slate-200 bg-slate-50">
                    <tr>
                      <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                        Staff
                      </th>

                      <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                        Email
                      </th>

                      <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                        Staff ID
                      </th>

                      <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                        Joined
                      </th>

                      <th class="px-6 py-3.5 text-right text-[11px] font-bold uppercase tracking-wider text-slate-500">
                        Actions
                      </th>
                    </tr>
                  </thead>

                  <tbody class="divide-y divide-slate-200">
                    <%= for staff <- @staff do %>
                      <tr class="transition hover:bg-slate-50">
                        <!-- STAFF -->
                        <td class="whitespace-nowrap px-6 py-4">
                          <div class="flex items-center gap-3">
                            <div class="flex h-9 w-9 items-center justify-center rounded-full bg-[#0F172A] text-xs font-bold text-white shadow-sm">
                              <%= String.first(staff.name || "?") |> String.upcase() %>
                            </div>

                            <div>
                              <p class="text-xs font-bold text-slate-900">
                                <%= staff.name %>
                              </p>

                              <p class="mt-0.5 text-[11px] text-slate-500">
                                Support Staff
                              </p>
                            </div>
                          </div>
                        </td>

                        <!-- EMAIL -->
                        <td class="whitespace-nowrap px-6 py-4">
                          <span class="text-xs font-medium text-slate-600">
                            <%= staff.email %>
                          </span>
                        </td>

                        <!-- IDENTIFIER -->
                        <td class="whitespace-nowrap px-6 py-4">
                          <span class="rounded-md border border-slate-200 bg-slate-100 px-2.5 py-1 font-mono text-[11px] font-bold text-slate-800">
                            <%= staff.staff_identifier %>
                          </span>
                        </td>

                        <!-- CREATED -->
                        <td class="whitespace-nowrap px-6 py-4">
                          <div>
                            <p class="text-xs font-bold text-slate-900">
                              <%= Calendar.strftime(staff.inserted_at, "%d %b %Y") %>
                            </p>

                            <p class="mt-0.5 text-[11px] text-slate-500">
                              <%= Calendar.strftime(staff.inserted_at, "%I:%M %p") %>
                            </p>
                          </div>
                        </td>

                        <!-- ACTIONS -->
                        <td class="whitespace-nowrap px-6 py-4">
                          <div class="flex items-center justify-end gap-2">
                            <.link
                              navigate={~p"/support/manager/staff/#{staff.staff_id}/edit"}
                              class="rounded-lg border border-slate-200 bg-white px-3 py-1.5 text-xs font-semibold text-slate-800 shadow-sm transition hover:bg-slate-50"
                            >
                              Edit
                            </.link>

                            <button
                              type="button"
                              phx-click="delete_staff"
                              phx-value-id={staff.staff_id}
                              data-confirm="Are you sure you want to delete this staff account?"
                              class="rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-xs font-semibold text-rose-700 shadow-sm transition hover:bg-rose-100"
                            >
                              Delete
                            </button>
                          </div>
                        </td>
                      </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>
            </div>
          <% end %>

          <!-- INFORMATION CARD -->
          <div class="mt-6 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
            <div class="flex gap-4">
              <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-slate-100 text-slate-600">
                <svg
                  class="h-5 w-5"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="1.7"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M13 16h-1v-4h-1m1-4h.01M12 21a9 9 0 100-18 9 9 0 000 18z"
                  />
                </svg>
              </div>

              <div>
                <h3 class="text-xs font-bold uppercase tracking-wider text-slate-900">
                  Staff account management
                </h3>

                <p class="mt-1 text-xs leading-5 text-slate-500">
                  Managers can create staff accounts and update their name or email. Staff members use their assigned credentials to access requests assigned to them.
                </p>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
    """
  end
end

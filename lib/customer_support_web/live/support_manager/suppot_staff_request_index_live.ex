defmodule CustomerSupportWeb.SupportStaffRequestIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests

  on_mount {CustomerSupportWeb.StaffAuthHook, :default}

  def mount(_params, _session, socket) do
    staff_id = socket.assigns.current_staff.staff_id

    filters = %{
      status: [],
      priority: [],
      category: [],
      date_from: nil,
      date_to: nil
    }

    requests =
      Requests.search_and_filter_staff_requests(
        staff_id,
        filters
      )

    {:ok,
     socket
     |> assign(:requests, requests)
     |> assign(:filters, filters)}
  end

  def handle_event("apply_filters", params, socket) do
    filters = %{
      status: Map.get(params, "status", []),
      priority: Map.get(params, "priority", []),
      category: Map.get(params, "category", []),
      date_from: Map.get(params, "date_from"),
      date_to: Map.get(params, "date_to")
    }

    requests =
      Requests.search_and_filter_staff_requests(
        socket.assigns.current_staff.staff_id,
        filters
      )

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> assign(:requests, requests)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#F5F0E9] text-[#112250]">

      <!-- TOP NAVIGATION -->
      <header class="border-b border-[#D9CBC2] bg-white">
        <div class="mx-auto flex max-w-7xl items-center justify-between px-6 py-4 lg:px-8">

          <div>
            <p class="text-xs font-semibold uppercase tracking-[0.2em] text-[#3C5070]">
              Customer Support
            </p>

            <h1 class="mt-1 text-xl font-bold text-[#112250]">
              My Requests
            </h1>
          </div>

          <div class="flex items-center gap-3">

            <div class="hidden text-right sm:block">
              <p class="text-sm font-semibold text-[#112250]">
                <%= @current_staff.name %>
              </p>

              <p class="text-xs text-[#3C5070]">
                <%= @current_staff.email %>
              </p>
            </div>

            <.link
              navigate={~p"/support/staff/dashboard"}
              class="rounded-lg border border-[#D9CBC2] bg-white px-4 py-2 text-sm font-semibold text-[#3C5070] transition hover:bg-[#F5F0E9]"
            >
              Dashboard
            </.link>

          </div>

        </div>
      </header>

      <!-- MAIN -->
      <main class="mx-auto max-w-7xl px-6 py-8 lg:px-8">

        <!-- PAGE HEADER -->
        <div class="mb-8">
          <p class="text-sm font-semibold uppercase tracking-wider text-[#3C5070]">
            Assigned Work
          </p>

          <h2 class="mt-1 text-3xl font-bold tracking-tight text-[#112250]">
            My Customer Requests
          </h2>

          <p class="mt-2 max-w-2xl text-sm leading-6 text-[#3C5070]">
            View and manage the customer requests currently assigned to you.
          </p>
        </div>

        <!-- FILTER CARD -->
        <div class="mb-6 rounded-2xl border border-[#D9CBC2] bg-white shadow-sm">

          <div class="border-b border-[#D9CBC2] px-6 py-5">
            <div class="flex items-center justify-between">

              <div>
                <h3 class="text-lg font-bold text-[#112250]">
                  Filter Requests
                </h3>

                <p class="mt-1 text-sm text-[#3C5070]">
                  Narrow your assigned requests by status, priority, category, or date.
                </p>
              </div>

              <div class="hidden rounded-lg bg-[#F5F0E9] px-3 py-2 text-xs font-semibold text-[#3C5070] sm:block">
                <%= length(@requests) %> results
              </div>

            </div>
          </div>

          <.form
            id="request-filters"
            for={%{}}
            phx-submit="apply_filters"
            class="p-6"
          >

            <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-4">

              <!-- STATUS -->
              <details class="group rounded-xl border border-[#D9CBC2] bg-[#FCFAF7] p-4">
                <summary class="cursor-pointer list-none text-sm font-semibold text-[#112250]">
                  <div class="flex items-center justify-between">
                    <span>Status</span>
                    <span class="text-[#3C5070] transition group-open:rotate-180">
                      ▼
                    </span>
                  </div>
                </summary>

                <div class="mt-4 space-y-3">

                  <%= for status <- ["Open", "In Progress", "Waiting for Customer", "Resolved", "Closed", "Reopened"] do %>
                    <label class="flex cursor-pointer items-center gap-3 text-sm text-[#3C5070]">
                      <input
                        type="checkbox"
                        name="status[]"
                        value={status}
                        checked={status in @filters.status}
                        class="h-4 w-4 rounded border-[#D9CBC2] text-[#112250] focus:ring-[#3C5070]"
                      />
                      <span><%= status %></span>
                    </label>
                  <% end %>

                </div>
              </details>

              <!-- PRIORITY -->
              <details class="group rounded-xl border border-[#D9CBC2] bg-[#FCFAF7] p-4">
                <summary class="cursor-pointer list-none text-sm font-semibold text-[#112250]">
                  <div class="flex items-center justify-between">
                    <span>Priority</span>
                    <span class="text-[#3C5070] transition group-open:rotate-180">
                      ▼
                    </span>
                  </div>
                </summary>

                <div class="mt-4 space-y-3">

                  <%= for priority <- ["Low", "Medium", "High", "Critical"] do %>
                    <label class="flex cursor-pointer items-center gap-3 text-sm text-[#3C5070]">
                      <input
                        type="checkbox"
                        name="priority[]"
                        value={priority}
                        checked={priority in @filters.priority}
                        class="h-4 w-4 rounded border-[#D9CBC2] text-[#112250] focus:ring-[#3C5070]"
                      />
                      <span><%= priority %></span>
                    </label>
                  <% end %>

                </div>
              </details>

              <!-- CATEGORY -->
              <details class="group rounded-xl border border-[#D9CBC2] bg-[#FCFAF7] p-4">
                <summary class="cursor-pointer list-none text-sm font-semibold text-[#112250]">
                  <div class="flex items-center justify-between">
                    <span>Category</span>
                    <span class="text-[#3C5070] transition group-open:rotate-180">
                      ▼
                    </span>
                  </div>
                </summary>

                <div class="mt-4 space-y-3">

                  <%= for category <- ["Technical", "Billing", "Account", "General"] do %>
                    <label class="flex cursor-pointer items-center gap-3 text-sm text-[#3C5070]">
                      <input
                        type="checkbox"
                        name="category[]"
                        value={category}
                        checked={category in @filters.category}
                        class="h-4 w-4 rounded border-[#D9CBC2] text-[#112250] focus:ring-[#3C5070]"
                      />
                      <span><%= category %></span>
                    </label>
                  <% end %>

                </div>
              </details>

              <!-- DATE -->
              <details class="group rounded-xl border border-[#D9CBC2] bg-[#FCFAF7] p-4">
                <summary class="cursor-pointer list-none text-sm font-semibold text-[#112250]">
                  <div class="flex items-center justify-between">
                    <span>Date Range</span>
                    <span class="text-[#3C5070] transition group-open:rotate-180">
                      ▼
                    </span>
                  </div>
                </summary>

                <div class="mt-4 space-y-4">

                  <div>
                    <label class="mb-1.5 block text-xs font-semibold text-[#3C5070]">
                      From
                    </label>

                    <input
                      type="date"
                      name="date_from"
                      value={@filters.date_from || ""}
                      class="w-full rounded-lg border border-[#D9CBC2] bg-white px-3 py-2 text-sm text-[#112250] focus:border-[#3C5070] focus:outline-none focus:ring-1 focus:ring-[#3C5070]"
                    />
                  </div>

                  <div>
                    <label class="mb-1.5 block text-xs font-semibold text-[#3C5070]">
                      To
                    </label>

                    <input
                      type="date"
                      name="date_to"
                      value={@filters.date_to || ""}
                      class="w-full rounded-lg border border-[#D9CBC2] bg-white px-3 py-2 text-sm text-[#112250] focus:border-[#3C5070] focus:outline-none focus:ring-1 focus:ring-[#3C5070]"
                    />
                  </div>

                </div>
              </details>

            </div>

            <div class="mt-6 flex justify-end">
              <button
                type="submit"
                class="inline-flex items-center rounded-lg bg-[#112250] px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-[#3C5070]"
              >
                Apply Filters
              </button>
            </div>

          </.form>
        </div>

        <!-- REQUEST TABLE -->
        <div class="overflow-hidden rounded-2xl border border-[#D9CBC2] bg-white shadow-sm">

          <div class="flex items-center justify-between border-b border-[#D9CBC2] px-6 py-5">

            <div>
              <h3 class="text-lg font-bold text-[#112250]">
                Assigned Requests
              </h3>

              <p class="mt-1 text-sm text-[#3C5070]">
                Requests currently assigned to your account.
              </p>
            </div>

            <span class="rounded-full bg-[#F5F0E9] px-3 py-1 text-xs font-semibold text-[#3C5070]">
              <%= length(@requests) %> requests
            </span>

          </div>

          <%= if @requests == [] do %>

            <div class="px-6 py-16 text-center">

              <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-[#F5F0E9]">
                <svg
                  class="h-7 w-7 text-[#3C5070]"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="1.7"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a3 3 0 006 0M9 5a3 3 0 016 0m-5 6h4m-4 4h4"
                  />
                </svg>
              </div>

              <h3 class="mt-5 text-lg font-bold text-[#112250]">
                No requests found
              </h3>

              <p class="mt-2 text-sm text-[#3C5070]">
                There are no requests matching the selected filters.
              </p>

            </div>

          <% else %>

            <div class="overflow-x-auto">

              <table class="min-w-full text-left">

                <thead class="border-b border-[#D9CBC2] bg-[#F5F0E9]">

                  <tr>

                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                      Request
                    </th>

                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                      Customer
                    </th>

                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                      Status
                    </th>

                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                      Priority
                    </th>

                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                      Category
                    </th>

                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                      Created
                    </th>

                    <th class="px-6 py-4 text-right text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                      Action
                    </th>

                  </tr>

                </thead>

                <tbody class="divide-y divide-[#D9CBC2]">

                  <%= for request <- @requests do %>

                    <tr class="transition hover:bg-[#FCFAF7]">

                      <!-- REQUEST -->
                      <td class="max-w-xs px-6 py-5">

                        <.link
                          navigate={~p"/support/staff/requests/#{request.request_id}"}
                          class="group"
                        >
                          <p class="truncate font-semibold text-[#112250] group-hover:text-[#3C5070]">
                            <%= request.title %>
                          </p>

                          <p class="mt-1 font-mono text-xs text-[#3C5070]">
                            <%= request.request_id %>
                          </p>
                        </.link>

                      </td>

                      <!-- CUSTOMER -->
                      <td class="whitespace-nowrap px-6 py-5">

                        <div class="flex items-center gap-3">

                          <div class="flex h-9 w-9 items-center justify-center rounded-full bg-[#112250] text-xs font-bold text-white">
                            <%= String.first(request.customer.name || "?") |> String.upcase() %>
                          </div>

                          <span class="text-sm font-medium text-[#112250]">
                            <%= request.customer.name %>
                          </span>

                        </div>

                      </td>

                      <!-- STATUS -->
                      <td class="whitespace-nowrap px-6 py-5">

                        <span class={[
                          "inline-flex rounded-full px-3 py-1 text-xs font-semibold",
                          case request.status do
                            "Open" ->
                              "bg-blue-50 text-blue-700"

                            "In Progress" ->
                              "bg-amber-50 text-amber-700"

                            "Waiting for Customer" ->
                              "bg-purple-50 text-purple-700"

                            "Resolved" ->
                              "bg-emerald-50 text-emerald-700"

                            "Closed" ->
                              "bg-gray-100 text-gray-700"

                            "Reopened" ->
                              "bg-red-50 text-red-700"

                            _ ->
                              "bg-gray-100 text-gray-700"
                          end
                        ]}>
                          <%= request.status %>
                        </span>

                      </td>

                      <!-- PRIORITY -->
                      <td class="whitespace-nowrap px-6 py-5">

                        <span class={[
                          "text-sm font-semibold",
                          case request.priority do
                            "Critical" ->
                              "text-red-700"

                            "High" ->
                              "text-orange-700"

                            "Medium" ->
                              "text-amber-700"

                            "Low" ->
                              "text-emerald-700"

                            _ ->
                              "text-[#3C5070]"
                          end
                        ]}>
                          <%= request.priority %>
                        </span>

                      </td>

                      <!-- CATEGORY -->
                      <td class="whitespace-nowrap px-6 py-5">

                        <span class="rounded-md bg-[#F5F0E9] px-2.5 py-1 text-xs font-semibold text-[#3C5070]">
                          <%= request.category %>
                        </span>

                      </td>

                      <!-- DATE -->
                      <td class="whitespace-nowrap px-6 py-5">

                        <span class="text-sm text-[#3C5070]">
                          <%= Calendar.strftime(request.inserted_at, "%d %b %Y") %>
                        </span>

                      </td>

                      <!-- ACTION -->
                      <td class="whitespace-nowrap px-6 py-5 text-right">

                        <.link
                          navigate={~p"/support/staff/requests/#{request.request_id}"}
                          class="rounded-lg border border-[#D9CBC2] bg-white px-3 py-2 text-xs font-semibold text-[#112250] transition hover:bg-[#F5F0E9]"
                        >
                          View Request
                        </.link>

                      </td>

                    </tr>

                  <% end %>

                </tbody>

              </table>

            </div>

          <% end %>

        </div>

      </main>
    </div>
    """
  end
end

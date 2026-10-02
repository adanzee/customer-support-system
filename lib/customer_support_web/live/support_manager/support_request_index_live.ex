defmodule CustomerSupportWeb.SupportRequestIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Repo
  alias CustomerSupport.Requests
  alias CustomerSupport.Requests.Request
  alias CustomerSupport.SupportStaff
  alias CustomerSupport.ActivityLogs

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(_params, _session, socket) do
    requests =
      Requests.search_and_filter_requests("", %{})

    staff = SupportStaff.list_staff()

    {:ok,
     socket
     |> assign(:requests, requests)
     |> assign(:staff, staff)
     |> assign(:filters, %{
       status: [],
       priority: [],
       category: [],
       staff_id: [],
       date_from: nil,
       date_to: nil
     })}
  end

  def handle_event("apply_filters", params, socket) do
    filters = %{
      status: Map.get(params, "status", []),
      priority: Map.get(params, "priority", []),
      category: Map.get(params, "category", []),
      staff_id: Map.get(params, "staff_id", []),
      date_from: Map.get(params, "date_from"),
      date_to: Map.get(params, "date_to")
    }

    search_query = Map.get(params, "search_query", "")

    requests =
      Requests.search_and_filter_requests(search_query, filters)

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> assign(:requests, requests)}
  end

  def handle_event("quick_filter", %{"status" => "all"}, socket) do
    filters = %{
      status: [],
      priority: [],
      category: [],
      staff_id: [],
      date_from: nil,
      date_to: nil
    }

    requests =
      Requests.search_and_filter_requests("", filters)

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> assign(:requests, requests)}
  end

  def handle_event("quick_filter", %{"status" => status}, socket) do
    filters = %{
      status: [status],
      priority: [],
      category: [],
      staff_id: [],
      date_from: nil,
      date_to: nil
    }

    requests =
      Requests.search_and_filter_requests("", filters)

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> assign(:requests, requests)}
  end

  def handle_event("quick_filter", %{"staff" => "unassigned"}, socket) do
    filters = %{
      status: [],
      priority: [],
      category: [],
      staff_id: [""],
      date_from: nil,
      date_to: nil
    }

    requests =
      Requests.search_and_filter_requests("", filters)

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> assign(:requests, requests)}
  end

  def handle_event("clear_filters", _params, socket) do
    filters = %{
      status: [],
      priority: [],
      category: [],
      staff_id: [],
      date_from: nil,
      date_to: nil
    }

    requests =
      Requests.search_and_filter_requests("", filters)

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> assign(:requests, requests)}
  end

  def handle_event(
        "assign_staff",
        %{"request_id" => request_id, "staff_id" => staff_id},
        socket
      ) do
    request =
      Request
      |> Repo.get!(request_id)
      |> Repo.preload(:staff)

    current_manager = socket.assigns.current_manager
    old_staff = request.staff

    changeset =
      Request.changeset(request, %{staff_id: staff_id})

    case Repo.update(changeset) do
      {:ok, _updated_request} ->
        new_staff =
          if staff_id == "" do
            nil
          else
            SupportStaff.get_staff(staff_id)
          end

        action =
          cond do
            is_nil(old_staff) and new_staff ->
              "request_assigned"

            old_staff && new_staff ->
              "request_reassigned"

            old_staff && is_nil(new_staff) ->
              "request_unassigned"

            true ->
              "request_updated"
          end

        description =
          cond do
            action == "request_assigned" ->
              "Request #{request.request_id} was assigned to #{new_staff.name}."

            action == "request_reassigned" ->
              "Request #{request.request_id} was reassigned from #{old_staff.name} to #{new_staff.name}."

            action == "request_unassigned" ->
              "Request #{request.request_id} was unassigned from #{old_staff.name}."

            true ->
              "Request #{request.request_id} assignment was updated."
          end

        ActivityLogs.create_activity(%{
          action: action,
          description: description,
          entity_type: "request",
          entity_id: request.request_id,
          actor_type: "manager",
          actor_id: current_manager.manager_id
        })

        requests =
          Requests.search_and_filter_requests(
            "",
            socket.assigns.filters
          )

        {:noreply,
         socket
         |> assign(:requests, requests)
         |> put_flash(:info, "Staff assignment updated successfully.")}

      {:error, _changeset} ->
        {:noreply,
         put_flash(socket, :error, "Unable to update staff assignment.")}
    end
  end

  def render(assigns) do
  ~H"""
  <div class="flex min-h-screen bg-[#F8FAFC] text-[#0F172A] antialiased">

    <!-- SIDEBAR -->
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
            class="flex items-center gap-3 rounded-xl px-4 py-3 text-xs font-semibold text-slate-400 transition hover:bg-slate-800/50 hover:text-white"
          >
            Dashboard
          </.link>

          <.link
            navigate={~p"/support/manager/requests"}
            class="flex items-center justify-between rounded-xl bg-blue-600 px-4 py-3 text-xs font-semibold text-white shadow-sm"
          >
            <span>Requests</span>
            <span class="h-2 w-2 rounded-full bg-amber-400"></span>
          </.link>

          <.link
            navigate={~p"/support/manager/staff"}
            class="flex items-center gap-3 rounded-xl px-4 py-3 text-xs font-semibold text-slate-400 transition hover:bg-slate-800/50 hover:text-white"
          >
            Staff Management
          </.link>

          <.link
            navigate={~p"/support/manager/activity"}
            class="flex items-center gap-3 rounded-xl px-4 py-3 text-xs font-semibold text-slate-400 transition hover:bg-slate-800/50 hover:text-white"
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

    <!-- MAIN -->
    <div class="flex min-w-0 flex-1 flex-col">

      <!-- TOP HEADER -->
      <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/90 px-8 py-4 backdrop-blur-md">

        <div>
          <p class="text-xs font-semibold uppercase tracking-wider text-slate-500">
            Management Portal
          </p>

          <p class="mt-0.5 text-[11px] text-slate-400">
            Request Management
          </p>
        </div>

        <div class="flex items-center gap-6">

          <div class="text-right">
            <p class="text-xs font-bold text-slate-900">
              <%= @current_manager.name %>
            </p>

            <p class="text-[11px] font-medium text-slate-500">
              <%= @current_manager.email %>
            </p>
          </div>

          <div class="h-6 w-px bg-slate-200"></div>

          <.link
            href={~p"/support/logout"}
            method="post"
            class="rounded-lg border border-slate-200 bg-white px-3.5 py-1.5 text-xs font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50"
          >
            LOGOUT
          </.link>

        </div>
      </header>

      <!-- CONTENT -->
      <main class="flex-1 overflow-y-auto px-8 py-8">

        <!-- PAGE HEADER -->
        <div class="mb-8 flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">

          <div>
            <div class="flex items-center gap-2">
              <span class="h-2 w-2 rounded-full bg-blue-500"></span>

              <p class="text-xs font-bold uppercase tracking-wider text-slate-500">
                Request Management
              </p>
            </div>

            <h1 class="mt-1 text-3xl font-extrabold tracking-tight text-slate-900">
              Customer Requests
            </h1>

            <p class="mt-1 text-sm text-slate-500">
              Review customer requests and manage staff assignments.
            </p>
          </div>

          <!-- SUMMARY -->
          <div class="grid grid-cols-3 gap-3">

            <div class="min-w-[110px] rounded-xl border border-slate-200 bg-white p-3.5 shadow-sm">
              <p class="text-[11px] font-bold uppercase tracking-wider text-slate-500">
                Total
              </p>

              <p class="mt-1 text-2xl font-black text-slate-900">
                <%= length(@requests) %>
              </p>
            </div>

            <div class="min-w-[110px] rounded-xl border border-amber-200 bg-amber-50 p-3.5 shadow-sm">
              <p class="text-[11px] font-bold uppercase tracking-wider text-amber-800">
                Active
              </p>

              <p class="mt-1 text-2xl font-black text-amber-900">
                <%= Enum.count(@requests, fn request ->
                  request.status in ["Open", "In Progress", "Waiting for Customer", "Reopened"]
                end) %>
              </p>
            </div>

            <div class="min-w-[110px] rounded-xl border border-rose-200 bg-rose-50 p-3.5 shadow-sm">
              <p class="text-[11px] font-bold uppercase tracking-wider text-rose-800">
                High Priority
              </p>

              <p class="mt-1 text-2xl font-black text-rose-900">
                <%= Enum.count(@requests, fn request ->
                  request.priority in ["High", "Critical"]
                end) %>
              </p>
            </div>

          </div>
        </div>

        <!-- FILTER CARD -->
        <div class="mb-6 overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">

          <div class="border-b border-slate-200 bg-slate-50 px-6 py-4">

            <div class="flex flex-wrap items-center justify-between gap-4">

              <div class="flex items-center gap-2">
                <svg
                  class="h-4 w-4 text-slate-500"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="2"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"
                  />
                </svg>

                <h2 class="text-sm font-bold uppercase tracking-wider text-slate-900">
                  Filter & Search
                </h2>
              </div>

              <div class="flex items-center gap-3">

                <button
                  type="button"
                  phx-click="clear_filters"
                  class="text-xs font-semibold text-slate-500 underline-offset-4 transition hover:text-slate-900 hover:underline"
                >
                  Reset Filters
                </button>

                <span class="rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-bold text-slate-900">
                  <%= length(@requests) %> Matches
                </span>

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
              <details class="group rounded-xl border border-slate-200 bg-slate-50 p-3.5 transition hover:border-slate-400">
                <summary class="cursor-pointer list-none text-xs font-bold uppercase tracking-wider text-slate-900">
                  <div class="flex items-center justify-between">
                    <span>
                      Status
                      <%= if length(@filters.status) > 0 do %>
                        (<%= length(@filters.status) %>)
                      <% end %>
                    </span>

                    <svg
                      class="h-4 w-4 text-slate-500 transition group-open:rotate-180"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M19 9l-7 7-7-7"
                      />
                    </svg>
                  </div>
                </summary>

                <div class="mt-3 space-y-2.5 border-t border-slate-200 pt-3">

                  <%= for status <- [
                    "Open",
                    "In Progress",
                    "Waiting for Customer",
                    "Resolved",
                    "Closed",
                    "Reopened"
                  ] do %>

                    <label class="flex cursor-pointer items-center gap-2.5 text-xs font-medium text-slate-600 hover:text-slate-900">

                      <input
                        type="checkbox"
                        name="status[]"
                        value={status}
                        checked={status in @filters.status}
                        class="h-4 w-4 rounded border-slate-300 text-slate-900 focus:ring-slate-500"
                      />

                      <span><%= status %></span>

                    </label>

                  <% end %>

                </div>
              </details>

              <!-- PRIORITY -->
              <details class="group rounded-xl border border-slate-200 bg-slate-50 p-3.5 transition hover:border-slate-400">
                <summary class="cursor-pointer list-none text-xs font-bold uppercase tracking-wider text-slate-900">
                  <div class="flex items-center justify-between">

                    <span>
                      Priority
                      <%= if length(@filters.priority) > 0 do %>
                        (<%= length(@filters.priority) %>)
                      <% end %>
                    </span>

                    <svg
                      class="h-4 w-4 text-slate-500 transition group-open:rotate-180"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M19 9l-7 7-7-7"
                      />
                    </svg>

                  </div>
                </summary>

                <div class="mt-3 space-y-2.5 border-t border-slate-200 pt-3">

                  <%= for priority <- ["Low", "Medium", "High", "Critical"] do %>

                    <label class="flex cursor-pointer items-center gap-2.5 text-xs font-medium text-slate-600 hover:text-slate-900">

                      <input
                        type="checkbox"
                        name="priority[]"
                        value={priority}
                        checked={priority in @filters.priority}
                        class="h-4 w-4 rounded border-slate-300 text-slate-900 focus:ring-slate-500"
                      />

                      <span><%= priority %></span>

                    </label>

                  <% end %>

                </div>
              </details>

              <!-- CATEGORY -->
              <details class="group rounded-xl border border-slate-200 bg-slate-50 p-3.5 transition hover:border-slate-400">
                <summary class="cursor-pointer list-none text-xs font-bold uppercase tracking-wider text-slate-900">
                  <div class="flex items-center justify-between">

                    <span>
                      Category
                      <%= if length(@filters.category) > 0 do %>
                        (<%= length(@filters.category) %>)
                      <% end %>
                    </span>

                    <svg
                      class="h-4 w-4 text-slate-500 transition group-open:rotate-180"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M19 9l-7 7-7-7"
                      />
                    </svg>

                  </div>
                </summary>

                <div class="mt-3 space-y-2.5 border-t border-slate-200 pt-3">

                  <%= for category <- ["Technical", "Billing", "Account", "General"] do %>

                    <label class="flex cursor-pointer items-center gap-2.5 text-xs font-medium text-slate-600 hover:text-slate-900">

                      <input
                        type="checkbox"
                        name="category[]"
                        value={category}
                        checked={category in @filters.category}
                        class="h-4 w-4 rounded border-slate-300 text-slate-900 focus:ring-slate-500"
                      />

                      <span><%= category %></span>

                    </label>

                  <% end %>

                </div>
              </details>

              <!-- DATE -->
              <details class="group rounded-xl border border-slate-200 bg-slate-50 p-3.5 transition hover:border-slate-400">
                <summary class="cursor-pointer list-none text-xs font-bold uppercase tracking-wider text-slate-900">

                  <div class="flex items-center justify-between">

                    <span>Date Range</span>

                    <svg
                      class="h-4 w-4 text-slate-500 transition group-open:rotate-180"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M19 9l-7 7-7-7"
                      />
                    </svg>

                  </div>
                </summary>

                <div class="mt-3 space-y-3 border-t border-slate-200 pt-3">

                  <div>
                    <label class="mb-1 block text-[10px] font-bold uppercase tracking-wider text-slate-500">
                      From
                    </label>

                    <input
                      type="date"
                      name="date_from"
                      value={@filters.date_from || ""}
                      class="w-full rounded-lg border border-slate-300 bg-white px-2.5 py-1.5 text-xs text-slate-900 focus:border-slate-500 focus:outline-none focus:ring-1 focus:ring-slate-500"
                    />
                  </div>

                  <div>
                    <label class="mb-1 block text-[10px] font-bold uppercase tracking-wider text-slate-500">
                      To
                    </label>

                    <input
                      type="date"
                      name="date_to"
                      value={@filters.date_to || ""}
                      class="w-full rounded-lg border border-slate-300 bg-white px-2.5 py-1.5 text-xs text-slate-900 focus:border-slate-500 focus:outline-none focus:ring-1 focus:ring-slate-500"
                    />
                  </div>

                </div>
              </details>

            </div>

            <div class="mt-5 flex justify-end">

              <button
                type="submit"
                class="rounded-lg bg-[#0F172A] px-5 py-2 text-xs font-bold text-white shadow-sm transition hover:bg-slate-800"
              >
                Apply Filters
              </button>

            </div>

          </.form>
        </div>

        <!-- REQUEST TABLE -->
        <div class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">

          <%= if @requests == [] do %>

            <!-- EMPTY STATE -->
            <div class="px-6 py-20 text-center">

              <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-2xl bg-slate-100 text-slate-500">

                <svg
                  class="h-8 w-8"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="1.5"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"
                  />
                </svg>

              </div>

              <h3 class="mt-4 text-base font-bold text-slate-900">
                No Requests Found
              </h3>

              <p class="mx-auto mt-1 max-w-sm text-xs text-slate-500">
                No customer requests match the current filters.
              </p>

              <button
                type="button"
                phx-click="clear_filters"
                class="mt-4 rounded-lg border border-slate-200 bg-white px-4 py-2 text-xs font-semibold text-slate-900 shadow-sm transition hover:bg-slate-50"
              >
                Clear Filters
              </button>

            </div>

          <% else %>

            <div class="overflow-x-auto">

              <table class="min-w-full text-left">

                <thead class="border-b border-slate-200 bg-slate-50">

                  <tr>

                    <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                      Request
                    </th>

                    <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                      Customer
                    </th>

                    <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                      Status
                    </th>

                    <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                      Priority
                    </th>

                    <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                      Category
                    </th>

                    <th class="px-6 py-3.5 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                      Assigned Staff
                    </th>

                    <th class="px-6 py-3.5 text-right text-[11px] font-bold uppercase tracking-wider text-slate-500">
                      Action
                    </th>

                  </tr>

                </thead>

                <tbody class="divide-y divide-slate-200">

                  <%= for request <- @requests do %>

                    <tr class="group transition hover:bg-slate-50">

                      <!-- REQUEST -->
                      <td class="max-w-xs px-6 py-4">

                        <.link
                          navigate={~p"/support/manager/requests/#{request.request_id}"}
                          class="block"
                        >

                          <p class="truncate text-sm font-bold text-slate-900 group-hover:text-blue-600">
                            <%= request.title %>
                          </p>

                          <p class="mt-0.5 font-mono text-[10px] text-slate-500">
                            #<%= request.request_id %>
                          </p>

                        </.link>

                      </td>

                      <!-- CUSTOMER -->
                      <td class="whitespace-nowrap px-6 py-4">

                        <div class="flex items-center gap-3">

                          <div class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-slate-800 text-xs font-bold text-white">
                            <%= String.first(request.customer.name || "?") |> String.upcase() %>
                          </div>

                          <div>
                            <p class="text-xs font-semibold text-slate-900">
                              <%= request.customer.name %>
                            </p>

                            <p class="text-[10px] text-slate-500">
                              <%= request.customer.email %>
                            </p>
                          </div>

                        </div>

                      </td>

                      <!-- STATUS -->
                      <td class="whitespace-nowrap px-6 py-4">

                        <span class={[
                          "inline-flex items-center rounded-full border px-2.5 py-1 text-[11px] font-bold",
                          case request.status do
                            "Open" ->
                              "border-blue-200 bg-blue-50 text-blue-700"

                            "In Progress" ->
                              "border-amber-200 bg-amber-50 text-amber-800"

                            "Waiting for Customer" ->
                              "border-purple-200 bg-purple-50 text-purple-700"

                            "Resolved" ->
                              "border-emerald-200 bg-emerald-50 text-emerald-800"

                            "Closed" ->
                              "border-slate-200 bg-slate-100 text-slate-700"

                            "Reopened" ->
                              "border-rose-200 bg-rose-50 text-rose-700"

                            _ ->
                              "border-slate-200 bg-slate-100 text-slate-700"
                          end
                        ]}>
                          <%= request.status %>
                        </span>

                      </td>

                      <!-- PRIORITY -->
                      <td class="whitespace-nowrap px-6 py-4">

                        <span class={[
                          "text-xs font-bold",
                          case request.priority do
                            "Critical" -> "text-rose-700"
                            "High" -> "text-orange-700"
                            "Medium" -> "text-amber-700"
                            "Low" -> "text-emerald-700"
                            _ -> "text-slate-500"
                          end
                        ]}>
                          <%= request.priority %>
                        </span>

                      </td>

                      <!-- CATEGORY -->
                      <td class="whitespace-nowrap px-6 py-4">

                        <span class="rounded-md border border-slate-200 bg-slate-100 px-2 py-1 text-[11px] font-semibold text-slate-600">
                          <%= request.category %>
                        </span>

                      </td>

                      <!-- STAFF ASSIGNMENT -->
                      <td class="px-6 py-4">

                        <form
                          phx-change="assign_staff"
                          class="min-w-[180px]"
                        >

                          <input
                            type="hidden"
                            name="request_id"
                            value={request.request_id}
                          />

                          <select
                            name="staff_id"
                            class="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-xs font-medium text-slate-700 focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
                          >

                            <option value="" selected={is_nil(request.staff_id)}>
                              Unassigned
                            </option>

                            <%= for staff <- @staff do %>

                              <option
                                value={staff.staff_id}
                                selected={request.staff_id == staff.staff_id}
                              >
                                <%= staff.name %> · <%= staff.staff_identifier %>
                              </option>

                            <% end %>

                          </select>

                        </form>

                      </td>

                      <!-- ACTION -->
                      <td class="whitespace-nowrap px-6 py-4 text-right">

                        <.link
                          navigate={~p"/support/manager/requests/#{request.request_id}"}
                          class="inline-flex items-center gap-1 rounded-lg border border-slate-200 bg-white px-3 py-1.5 text-xs font-semibold text-slate-900 shadow-sm transition hover:bg-slate-900 hover:text-white"
                        >
                          View
                          <svg
                            class="h-3 w-3"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                            stroke-width="2"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              d="M9 5l7 7-7 7"
                            />
                          </svg>
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
  </div>
  """
end
end

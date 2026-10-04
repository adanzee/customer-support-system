defmodule CustomerSupportWeb.SupportManagerRequestShowLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests
  alias CustomerSupport.Requests.Request
  alias CustomerSupport.SupportStaff
  alias CustomerSupport.ActivityLogs
  alias CustomerSupport.Repo
  alias CustomerSupportWeb.ManagerLayout
  alias CustomerSupport.Mailers.StaffMailer
  alias CustomerSupport.Mailer

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(%{"id" => request_id}, _session, socket) do
    case Requests.get_request(request_id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Request not found.")
         |> push_navigate(to: ~p"/support/manager/dashboard")}

      request ->
        request =
          Request
          |> Repo.get!(request.request_id)
          |> Repo.preload([:customer, :staff])

        staff = SupportStaff.list_staff()

        {:ok,
         socket
         |> assign(:request, request)
         |> assign(:staff, staff)}
    end
  end

  def handle_event("assign_staff", %{"staff_id" => staff_id}, socket) do
    request = socket.assigns.request
    current_manager = socket.assigns.current_manager

    old_staff = request.staff

    changeset =
      Request.changeset(
        request,
        %{staff_id: blank_to_nil(staff_id)}
      )

    case Repo.update(changeset) do
      {:ok, updated_request} ->
        updated_request =
          Repo.preload(
            updated_request,
            [:customer, :staff]
          )

           if updated_request.staff do
              result =
                updated_request.staff
                |> StaffMailer.request_assigned_email(updated_request)
                |> Mailer.deliver()

              IO.inspect(result, label: "STAFF ASSIGNMENT EMAIL")
            end

        action =
          cond do
            is_nil(old_staff) and updated_request.staff ->
              "request_assigned"

            old_staff && updated_request.staff ->
              "request_reassigned"

            old_staff && is_nil(updated_request.staff) ->
              "request_unassigned"

            true ->
              "request_updated"
          end

        description =
          cond do
            action == "request_assigned" ->
              "Request #{request.request_id} was assigned to #{updated_request.staff.name}."

            action == "request_reassigned" ->
              "Request #{request.request_id} was reassigned from #{old_staff.name} to #{updated_request.staff.name}."

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

        {:noreply,
         socket
         |> assign(:request, updated_request)
         |> put_flash(:info, "Staff assignment updated successfully.")}

      {:error, _changeset} ->
        {:noreply,
         put_flash(socket, :error, "Unable to update staff assignment.")}
    end
  end

  def handle_event("update_priority", %{"priority" => priority}, socket) do
  request_id = socket.assigns.request.request_id

  case Requests.update_request_priority(request_id, priority) do
    {:ok, request} ->
      {:noreply,
       socket
       |> assign(:request, request)
       |> put_flash(:info, "Priority updated successfully.")}

    {:error, _changeset} ->
      {:noreply,
       put_flash(socket, :error, "Unable to update priority.")}
  end
end

  defp blank_to_nil(""), do: nil
  defp blank_to_nil(value), do: value

  def render(assigns) do
    ~H"""
    <ManagerLayout.manager_layout current_path={~p"/support/manager/requests"}>

      <div class="min-h-full px-10 py-8">

        <!-- Header -->
        <div class="mb-8 flex items-start justify-between">

          <div>
            <.link
              navigate={~p"/support/manager/requests"}
              class="mb-4 inline-flex items-center gap-2 text-xs font-semibold text-slate-500 transition hover:text-blue-600"
            >
              ← Back to Requests
            </.link>

            <div class="flex items-center gap-4">
              <div>
                <p class="mb-1 text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400">
                  Support Request
                </p>

                <h1 class="text-2xl font-bold tracking-tight text-slate-900">
                  <%= @request.title %>
                </h1>

                <p class="mt-1 font-mono text-xs text-slate-400">
                  <%= @request.request_id %>
                </p>
              </div>


            </div>
          </div>



        </div>

        <!-- Flash messages -->
        <%= if Phoenix.Flash.get(@flash, :info) do %>
          <div class="mb-6 rounded-xl border border-emerald-200 bg-emerald-50 px-5 py-4 text-sm font-medium text-emerald-700">
            <div class="flex items-center gap-2">
              <span class="h-2 w-2 rounded-full bg-emerald-500"></span>
              <%= Phoenix.Flash.get(@flash, :info) %>
            </div>
          </div>
        <% end %>

        <%= if Phoenix.Flash.get(@flash, :error) do %>
          <div class="mb-6 rounded-xl border border-rose-200 bg-rose-50 px-5 py-4 text-sm font-medium text-rose-700">
            <div class="flex items-center gap-2">
              <span class="h-2 w-2 rounded-full bg-rose-500"></span>
              <%= Phoenix.Flash.get(@flash, :error) %>
            </div>
          </div>
        <% end %>

        <!-- Main grid -->
        <div class="grid grid-cols-1 gap-6 xl:grid-cols-3">

          <!-- Left: Request details -->
          <div class="space-y-6 xl:col-span-2">

            <!-- Request information -->
            <section class="rounded-2xl border border-slate-200 bg-white shadow-sm">

              <div class="border-b border-slate-100 px-6 py-5">
                <h2 class="text-sm font-bold text-slate-900">
                  Request Details
                </h2>

                <p class="mt-1 text-xs text-slate-400">
                  Information submitted by the customer.
                </p>
              </div>

              <div class="px-6 py-6">

                <div class="grid grid-cols-1 gap-6 sm:grid-cols-2">

                  <div>
                    <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                      Request ID
                    </p>

                    <p class="mt-2 break-all font-mono text-xs text-slate-700">
                      <%= @request.request_id %>
                    </p>
                  </div>

                  <div>
                    <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                      Category
                    </p>

                    <p class="mt-2 text-sm font-semibold text-slate-800">
                      <%= @request.category %>
                    </p>
                  </div>

                  <div>
                    <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                      Status
                    </p>

                    <div class="mt-2">
                      <%= status_badge(@request.status) %>
                    </div>
                  </div>

                  <div>
                    <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                      Priority
                    </p>

                    <.form for={%{}} phx-change="update_priority" class="mt-2">
                      <select
                        name="priority"
                        class="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm font-semibold text-slate-700 shadow-sm outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                      >
                        <%= for priority <- ["Low", "Medium", "High", "Critical"] do %>
                          <option
                            value={priority}
                            selected={@request.priority == priority}
                          >
                            <%= priority %>
                          </option>
                        <% end %>
                      </select>
                    </.form>
                  </div>

                </div>

                <div class="mt-8 border-t border-slate-100 pt-6">

                  <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                    Description
                  </p>

                  <div class="mt-3 rounded-xl bg-slate-50 p-5">
                    <p class="whitespace-pre-line text-sm leading-6 text-slate-700">
                      <%= @request.description %>
                    </p>
                  </div>

                </div>

              </div>
            </section>

            <!-- Customer -->
            <section class="rounded-2xl border border-slate-200 bg-white shadow-sm">

              <div class="border-b border-slate-100 px-6 py-5">
                <h2 class="text-sm font-bold text-slate-900">
                  Customer Information
                </h2>

                <p class="mt-1 text-xs text-slate-400">
                  Customer associated with this request.
                </p>
              </div>

              <div class="grid grid-cols-1 gap-6 px-6 py-6 sm:grid-cols-3">

                <div>
                  <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                    Name
                  </p>

                  <p class="mt-2 text-sm font-semibold text-slate-800">
                    <%= @request.customer.name %>
                  </p>
                </div>

                <div>
                  <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                    Email
                  </p>

                  <p class="mt-2 break-all text-sm text-slate-600">
                    <%= @request.customer.email %>
                  </p>
                </div>

                <div>
                  <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                    Phone
                  </p>

                  <p class="mt-2 text-sm text-slate-600">
                    <%= @request.customer.phone %>
                  </p>
                </div>

              </div>
            </section>

          </div>

          <!-- Right: Assignment -->
          <div class="space-y-6">

            <section class="rounded-2xl border border-slate-200 bg-white shadow-sm">

              <div class="border-b border-slate-100 px-6 py-5">
                <h2 class="text-sm font-bold text-slate-900">
                  Staff Assignment
                </h2>

                <p class="mt-1 text-xs text-slate-400">
                  Assign or reassign this request.
                </p>
              </div>

              <div class="px-6 py-6">

                <!-- Current assignment -->
                <div class="rounded-xl bg-slate-50 p-4">

                  <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">
                    Currently Assigned
                  </p>

                  <%= if @request.staff do %>
                    <div class="mt-3 flex items-center gap-3">

                      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-100 text-xs font-bold text-blue-700">
                        <%= initials(@request.staff.name) %>
                      </div>

                      <div class="min-w-0">
                        <p class="truncate text-sm font-bold text-slate-800">
                          <%= @request.staff.name %>
                        </p>

                        <p class="mt-0.5 font-mono text-[10px] text-slate-400">
                          <%= @request.staff.staff_identifier %>
                        </p>
                      </div>

                    </div>
                  <% else %>
                    <div class="mt-3 flex items-center gap-3">

                      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-200 text-slate-400">
                        —
                      </div>

                      <div>
                        <p class="text-sm font-semibold text-slate-600">
                          Unassigned
                        </p>

                        <p class="mt-0.5 text-xs text-slate-400">
                          No staff member assigned
                        </p>
                      </div>

                    </div>
                  <% end %>

                </div>

                <!-- Assignment form -->
                <div class="mt-6">

                  <.form for={%{}} phx-submit="assign_staff">

                    <label
                      for="staff_id"
                      class="mb-2 block text-[10px] font-bold uppercase tracking-widest text-slate-500"
                    >
                      Assign To
                    </label>

                    <select
                      id="staff_id"
                      name="staff_id"
                      class="w-full rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 shadow-sm outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                    >
                      <option value="">
                        Unassigned
                      </option>

                      <%= for staff <- @staff do %>
                        <option
                          value={staff.staff_id}
                          selected={
                            @request.staff &&
                              @request.staff.staff_id == staff.staff_id
                          }
                        >
                          <%= staff.staff_identifier %> — <%= staff.name %>
                        </option>
                      <% end %>
                    </select>

                    <button
                      type="submit"
                      class="mt-4 flex w-full items-center justify-center rounded-xl bg-blue-600 px-4 py-3 text-xs font-bold text-white shadow-sm transition hover:bg-blue-700"
                    >
                      Update Assignment
                    </button>

                  </.form>

                </div>

              </div>
            </section>

            <!-- Request summary -->
            <section class="rounded-2xl border border-slate-200 bg-white shadow-sm">

              <div class="border-b border-slate-100 px-6 py-5">
                <h2 class="text-sm font-bold text-slate-900">
                  Request Summary
                </h2>
              </div>

              <div class="space-y-5 px-6 py-6">

                <div class="flex items-center justify-between">
                  <span class="text-xs text-slate-400">
                    Status
                  </span>

                  <%= status_badge(@request.status) %>
                </div>

                <div class="flex items-center justify-between">
                  <span class="text-xs text-slate-400">
                    Priority
                  </span>

                  <%= priority_badge(@request.priority) %>
                </div>

                <div class="flex items-center justify-between">
                  <span class="text-xs text-slate-400">
                    Category
                  </span>

                  <span class="text-xs font-semibold text-slate-700">
                    <%= @request.category %>
                  </span>
                </div>

                <div class="flex items-center justify-between">
                  <span class="text-xs text-slate-400">
                    Assigned Staff
                  </span>

                  <span class="text-xs font-semibold text-slate-700">
                    <%= if @request.staff do %>
                      <%= @request.staff.staff_identifier %>
                    <% else %>
                      None
                    <% end %>
                  </span>
                </div>

              </div>
            </section>

          </div>

        </div>

      </div>
    </ManagerLayout.manager_layout>
    """
  end

  defp status_badge(status) do
    {bg, text, dot} =
      case status do
        "Open" ->
          {"bg-blue-50 border-blue-200", "text-blue-700", "bg-blue-500"}

        "In Progress" ->
          {"bg-amber-50 border-amber-200", "text-amber-700", "bg-amber-500"}

        "Waiting for Customer" ->
          {"bg-purple-50 border-purple-200", "text-purple-700", "bg-purple-500"}

        "Resolved" ->
          {"bg-emerald-50 border-emerald-200", "text-emerald-700", "bg-emerald-500"}

        "Closed" ->
          {"bg-slate-100 border-slate-200", "text-slate-600", "bg-slate-500"}

        "Reopened" ->
          {"bg-orange-50 border-orange-200", "text-orange-700", "bg-orange-500"}

        _ ->
          {"bg-slate-100 border-slate-200", "text-slate-600", "bg-slate-400"}
      end

    assigns = %{
      bg: bg,
      text: text,
      dot: dot,
      status: status
    }

    ~H"""
    <span class={"inline-flex items-center gap-1.5 rounded-full border px-2.5 py-1 text-[10px] font-bold uppercase tracking-wide #{@bg} #{@text}"}>
      <span class={"h-1.5 w-1.5 rounded-full #{@dot}"}></span>
      <%= @status %>
    </span>
    """
  end

  defp priority_badge(priority) do
    {bg, text} =
      case priority do
        "Critical" ->
          {"bg-rose-50 border-rose-200", "text-rose-700"}

        "High" ->
          {"bg-orange-50 border-orange-200", "text-orange-700"}

        "Medium" ->
          {"bg-amber-50 border-amber-200", "text-amber-700"}

        "Low" ->
          {"bg-slate-100 border-slate-200", "text-slate-600"}

        _ ->
          {"bg-slate-100 border-slate-200", "text-slate-600"}
      end

    assigns = %{
      bg: bg,
      text: text,
      priority: priority
    }

    ~H"""
    <span class={"inline-flex items-center rounded-full border px-2.5 py-1 text-[10px] font-bold uppercase tracking-wide #{@bg} #{@text}"}>
      <%= @priority %>
    </span>
    """
  end

  defp initials(name) do
    name
    |> String.split()
    |> Enum.take(2)
    |> Enum.map(&String.first/1)
    |> Enum.join()
    |> String.upcase()
  end
end

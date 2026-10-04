defmodule CustomerSupportWeb.StaffEditLive do
  use CustomerSupportWeb, :live_view

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  alias CustomerSupport.SupportStaff
  alias CustomerSupport.SupportStaff.Staff

  def mount(%{"id" => id}, _session, socket) do
    case SupportStaff.get_staff(id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Support staff member not found.")
         |> push_navigate(to: ~p"/support/manager/staff")}

      staff ->
        changeset = Staff.update_changeset(staff, %{})

        {:ok,
         socket
         |> assign(:staff, staff)
         |> assign(:form, to_form(changeset))}
    end
  end

  def handle_event("validate", %{"staff" => params}, socket) do
    changeset =
      socket.assigns.staff
      |> Staff.update_changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("update_staff", %{"staff" => params}, socket) do
    case SupportStaff.update_staff(socket.assigns.staff, params) do
      {:ok, _staff} ->
        {:noreply,
         socket
         |> put_flash(:info, "Support staff account updated successfully.")
         |> push_navigate(to: ~p"/support/manager/staff")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end


  def handle_event("disable_account", _params, socket) do
    case SupportStaff.disable_staff(socket.assigns.staff.staff_id) do
      {:ok, _staff} ->
        {:noreply,
        socket
        |> put_flash(:info, "Staff account disabled successfully.")
        |> push_navigate(to: ~p"/support/manager/staff")}

      {:error, :not_found} ->
        {:noreply,
        put_flash(socket, :error, "Support staff member not found.")}
    end
  end

  def handle_event("enable_account", _params, socket) do
    case SupportStaff.enable_staff(socket.assigns.staff.staff_id) do
      {:ok, staff} ->
        {:noreply,
        socket
        |> assign(:staff, staff)
        |> put_flash(:info, "Staff account enabled successfully.")}

      {:error, :not_found} ->
        {:noreply,
        put_flash(socket, :error, "Support staff member not found.")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#FFFFFF] text-[#112250]">
      <!-- TOP NAVIGATION -->
      <header class="border-b border-[#D9CBC2] bg-white">
        <div class="mx-auto flex max-w-7xl items-center justify-between px-6 py-4 lg:px-8">
          <div>
            <p class="text-xs font-semibold uppercase tracking-[0.2em] text-[#3C5070]">
              Customer Support
            </p>
            <h1 class="mt-1 text-xl font-bold text-[#112250]">
              Staff Management
            </h1>
          </div>

          <.link
            navigate={~p"/support/manager/staff"}
            class="inline-flex items-center gap-2 rounded-lg border border-[#D9CBC2] bg-white px-4 py-2 text-sm font-semibold text-[#3C5070] transition hover:bg-[#F5F0E9]"
          >
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Staff Directory
          </.link>
        </div>
      </header>

      <!-- MAIN CONTAINER -->
      <main class="mx-auto max-w-6xl px-6 py-10 lg:px-8">
        <!-- PAGE HEADER -->
        <div class="mb-8 flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-[#3C5070]">
              Account Settings
            </p>
            <h2 class="mt-1 text-3xl font-bold tracking-tight text-[#112250]">
              Edit Staff Profile
            </h2>
            <p class="mt-1 text-sm text-[#3C5070]">
              Modify account identity, system role permissions, and credential policies.
            </p>
          </div>

            <div class="flex items-center gap-2">
            <%= if @staff.status == "active" do %>
              <span class="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold text-emerald-700 border border-emerald-200">
                <span class="h-2 w-2 rounded-full bg-emerald-500"></span>
                Active Account
              </span>
            <% else %>
              <span class="inline-flex items-center gap-1.5 rounded-full bg-rose-50 px-3 py-1 text-xs font-bold text-rose-700 border border-rose-200">
                <span class="h-2 w-2 rounded-full bg-rose-500"></span>
                Disabled Account
              </span>
            <% end %>
          </div>
        </div>

        <!-- FLASH NOTIFICATIONS -->
        <div class="mb-6">
          <.flash kind={:info} flash={@flash} />
          <.flash kind={:error} flash={@flash} />
        </div>

        <!-- GRID LAYOUT -->
        <div class="grid grid-cols-1 gap-8 lg:grid-cols-12">
          <!-- PRIMARY FORM COLUMN (8 COLS) -->
          <div class="space-y-6 lg:col-span-8">
            <!-- STAFF SUMMARY BANNER -->
            <div class="rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm">
              <div class="flex items-center gap-5">
                <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-[#112250] text-xl font-bold text-white shadow-sm">
                  <%= String.first(@staff.name || "?") |> String.upcase() %>
                </div>

                <div class="min-w-0 flex-1">
                  <h3 class="truncate text-lg font-bold text-[#112250]">
                    <%= @staff.name %>
                  </h3>

                  <div class="mt-1 flex flex-wrap items-center gap-2.5">
                    <span class="rounded-md border border-[#D9CBC2] bg-[#F5F0E9] px-2.5 py-0.5 font-mono text-xs font-semibold text-[#112250]">
                      ID: <%= @staff.staff_identifier %>
                    </span>

                    <span class="text-xs font-medium text-[#3C5070]">
                      • Customer Support Representative
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <!-- EDIT FORM CARD -->
            <div class="overflow-hidden rounded-2xl border border-[#D9CBC2] bg-white shadow-sm">
              <div class="border-b border-[#D9CBC2] bg-[#FCFAF7] px-6 py-4">
                <h3 class="text-sm font-bold uppercase tracking-wider text-[#112250]">
                  Account Information
                </h3>
              </div>

              <div class="p-6 sm:p-8">
                <.form
                  for={@form}
                  phx-change="validate"
                  phx-submit="update_staff"
                  class="space-y-6"
                >
                  <!-- IMMUTABLE IDENTIFIER FIELD -->
                  <div>
                    <label class="mb-2 block text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                      Staff Identifier (System Key)
                    </label>

                    <div class="flex items-center justify-between rounded-lg border border-[#D9CBC2] bg-[#F5F0E9] px-3.5 py-2.5 text-sm font-mono font-semibold text-[#3C5070]">
                      <span><%= @staff.staff_identifier %></span>
                      <span class="inline-flex items-center gap-1 text-xs font-sans font-normal text-[#9A8F87]">
                        <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2V5a2 2 0 00-2-2H6a2 2 0 00-2 2v14a2 2 0 002 2zm6-8a3 3 0 100-6 3 3 0 000 6z" />
                        </svg>
                        Immutable
                      </span>
                    </div>
                    <p class="mt-1 text-xs text-[#9A8F87]">
                      Internal identifier assigned at creation; cannot be modified.
                    </p>
                  </div>

                  <!-- FULL NAME -->
                  <div>
                    <label
                      for={@form[:name].id}
                      class="mb-2 block text-xs font-bold uppercase tracking-wider text-[#112250]"
                    >
                      Full Name <span class="text-rose-600">*</span>
                    </label>

                    <.input
                      field={@form[:name]}
                      type="text"
                      placeholder="e.g. Jane Doe"
                      class="w-full rounded-lg border-[#D9CBC2] py-2 px-2 border border-gray-300 bg-white text-[#112250] placeholder:text-[#9A8F87] focus:border-[#3C5070] focus:ring-[#3C5070]"
                    />
                  </div>

                  <!-- EMAIL ADDRESS -->
                  <div>
                    <label
                      for={@form[:email].id}
                      class="mb-2 block text-xs font-bold uppercase tracking-wider text-[#112250]"
                    >
                      Email Address <span class="text-rose-600">*</span>
                    </label>

                    <.input
                      field={@form[:email]}
                      type="email"
                      placeholder="staff@company.com"
                      class="w-full rounded-lg border-[#D9CBC2] py-2 px-2 border border-gray-300 bg-white text-[#112250] placeholder:text-[#9A8F87] focus:border-[#3C5070] focus:ring-[#3C5070]"
                    />
                  </div>

                  <!-- ACTION BUTTONS -->
                  <div class="border-t border-[#D9CBC2] pt-6">
                    <div class="flex flex-col-reverse gap-3 sm:flex-row sm:justify-end">
                      <.link
                        navigate={~p"/support/manager/staff"}
                        class="inline-flex items-center justify-center rounded-lg border border-[#D9CBC2] bg-white px-5 py-2.5 text-sm font-semibold text-[#3C5070] transition hover:bg-[#F5F0E9]"
                      >
                        Cancel
                      </.link>

                      <button
                        type="submit"
                        phx-disable-with="Saving..."
                        class="inline-flex items-center justify-center rounded-lg bg-[#112250] px-6 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#3C5070] active:scale-[0.99]"
                      >
                        Save Changes
                      </button>
                    </div>
                  </div>
                </.form>
              </div>
            </div>
          </div>

          <!-- SIDEBAR: STAFF ACCOUNT & MANAGEMENT (4 COLS) -->
          <div class="space-y-6 lg:col-span-4">
            <!-- CARD 1: STAFF ACCOUNT SUMMARY -->
            <div class="overflow-hidden rounded-2xl border border-[#D9CBC2] bg-white shadow-sm">
              <div class="border-b border-[#D9CBC2] bg-[#FCFAF7] px-6 py-4">
                <h3 class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                  Staff Account
                </h3>
              </div>

              <div class="p-6 space-y-5">
                <div>
                  <p class="font-mono text-sm font-bold text-[#112250]">
                    <%= @staff.staff_identifier %>
                  </p>
                  <p class="text-base font-bold text-[#112250]">
                    <%= @staff.name %>
                  </p>
                </div>

                <div>
                  <%= if @staff.status == "active" do %>
                    <span class="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-2.5 py-1 text-xs font-bold text-emerald-700 border border-emerald-200">
                      <span class="h-2 w-2 rounded-full bg-emerald-500"></span>
                      ACTIVE
                    </span>
                  <% else %>
                    <span class="inline-flex items-center gap-1.5 rounded-full bg-rose-50 px-2.5 py-1 text-xs font-bold text-rose-700 border border-rose-200">
                      <span class="h-2 w-2 rounded-full bg-rose-500"></span>
                      DISABLED
                    </span>
                  <% end %>
                </div>

                <div>
                  <p class="text-xs font-semibold text-[#3C5070]">Created</p>
                  <p class="mt-0.5 text-sm font-medium text-[#112250]">
                    <%= if Map.has_key?(@staff, :inserted_at) and @staff.inserted_at, do: CustomerSupportWeb.DateTimeHelper.format_local(@staff.inserted_at), else: "" %>
                  </p>
                </div>

                <div>
                  <p class="text-xs font-semibold text-[#3C5070]">Assigned Requests</p>
                  <p class="mt-0.5 text-2xl font-bold text-[#112250]">
                    <%= Map.get(@staff, :assigned_requests_count, 4) %>
                  </p>
                </div>
              </div>
            </div>

            <!-- CARD 2: ACCOUNT MANAGEMENT -->
            <div class="overflow-hidden rounded-2xl border border-[#D9CBC2] bg-white shadow-sm">
              <div class="border-b border-[#D9CBC2] bg-[#FCFAF7] px-6 py-4">
                <h3 class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                  Account Management
                </h3>
              </div>

              <div class="p-6 space-y-4">
                <div>
                  <p class="mt-1 text-xs leading-relaxed text-[#3C5070]">
                    Staff must contact manager to change account details.
                  </p>
                </div>

                <div class="pt-2">
                  <%= if @staff.status == "active" do %>
                    <button
                      type="button"
                      phx-click="disable_account"
                      class="w-full rounded-lg border border-rose-300 bg-white px-4 py-2.5 text-xs font-bold text-rose-700 shadow-sm transition hover:bg-rose-50"
                    >
                      Disable Account
                    </button>
                  <% else %>
                    <button
                      type="button"
                      phx-click="enable_account"
                      class="w-full rounded-lg border border-emerald-300 bg-white px-4 py-2.5 text-xs font-bold text-emerald-700 shadow-sm transition hover:bg-emerald-50"
                    >
                      Enable Account
                    </button>
                  <% end %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
    """
  end
end

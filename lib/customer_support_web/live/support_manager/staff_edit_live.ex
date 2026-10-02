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
            <span class="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold text-emerald-700 border border-emerald-200">
              <span class="h-2 w-2 rounded-full bg-emerald-500"></span>
              Active Account
            </span>
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
                      class="w-full rounded-lg border-[#D9CBC2] bg-white text-[#112250] placeholder:text-[#9A8F87] focus:border-[#3C5070] focus:ring-[#3C5070]"
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
                      class="w-full rounded-lg border-[#D9CBC2] bg-white text-[#112250] placeholder:text-[#9A8F87] focus:border-[#3C5070] focus:ring-[#3C5070]"
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

          <!-- SIDEBAR: SYSTEM & GOVERNANCE CARDS (4 COLS) -->
          <div class="space-y-6 lg:col-span-4">

            <!-- SYSTEM PERMISSIONS CARD -->
            <div class="rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm">
              <h4 class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                Access & Security Scope
              </h4>

              <div class="mt-4 space-y-3">
                <div class="flex items-center justify-between rounded-lg border border-[#D9CBC2] bg-[#FCFAF7] p-2.5">
                  <span class="text-xs font-semibold text-[#112250]">Auth Provider</span>
                  <span class="font-mono text-xs font-bold text-[#3C5070]">Internal SAML/SSO</span>
                </div>

                <div class="flex items-center justify-between rounded-lg border border-[#D9CBC2] bg-[#FCFAF7] p-2.5">
                  <span class="text-xs font-semibold text-[#112250]">2FA Enforced</span>
                  <span class="inline-flex items-center gap-1 text-xs font-bold text-emerald-700">
                    <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>
                    Verified
                  </span>
                </div>
              </div>
            </div>

            <!-- SYSTEM AUDIT TRAIL CARD -->
            <div class="rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm">
              <h4 class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                System Audit Events
              </h4>

              <div class="mt-4 space-y-3">
                <div class="border-l-2 border-[#112250] pl-3">
                  <p class="text-xs font-semibold text-[#112250]">Account Created</p>
                  <p class="text-[11px] font-mono text-[#9A8F87]">2026-02-10 09:15 UTC</p>
                </div>

                <div class="border-l-2 border-[#D9CBC2] pl-3">

                </div>
              </div>
            </div>

            <!-- ACCOUNT MANAGEMENT DANGER ZONE -->
            <div class="rounded-2xl border border-rose-200 bg-rose-50/50 p-6 shadow-sm">
              <h4 class="text-xs font-bold uppercase tracking-wider text-rose-800">
                System Actions
              </h4>
              <p class="mt-1 text-xs text-rose-700 leading-relaxed">
                Deactivating standard access revokes API tokens and forces an immediate logout session across all active nodes.
              </p>

              <button
                type="button"
                class="mt-4 w-full rounded-lg border border-rose-300 bg-white px-3 py-2 text-xs font-bold text-rose-700 transition hover:bg-rose-100"
              >
                Deactivate Staff Account
              </button>
            </div>

          </div>

        </div>

      </main>
    </div>
    """
  end
end

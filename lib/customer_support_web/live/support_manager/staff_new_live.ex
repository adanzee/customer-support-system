defmodule CustomerSupportWeb.StaffNewLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff
  alias CustomerSupport.SupportStaff.Staff
  alias CustomerSupport.SupportStaff
  alias CustomerSupport.Requests

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

 def mount(_params, _session, socket) do
    changeset = Staff.changeset(%Staff{}, %{})

    {:ok,
    socket
    |> assign(form: to_form(changeset))
    |> assign(active_staff_count: SupportStaff.count_staff())
    |> assign(open_tickets_count: Requests.count_requests_by_status("Open"))
    |> assign(:show_password, false)
    |> assign(recent_additions: SupportStaff.list_recent_staff(2))}
  end

  def handle_event("validate", %{"staff" => params}, socket) do
    changeset =
      %Staff{}
      |> Staff.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("generate_password", _params, socket) do
    random_password = :crypto.strong_rand_bytes(8) |> Base.encode16() |> String.slice(0, 12)
    current_params = socket.assigns.form.params || %{}
    updated_params = Map.put(current_params, "password", random_password)

    {:noreply, assign(socket, form: to_form(Staff.changeset(%Staff{}, updated_params)))}
  end

  def handle_event("create_staff", %{"staff" => params}, socket) do
    case SupportStaff.create_staff(params) do
      {:ok, _staff} ->
        {:noreply,
         socket
         |> put_flash(:info, "Support staff member created successfully.")
         |> push_navigate(to: ~p"/support/manager/staff")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("toggle_password_visibility", _params, socket) do
    {:noreply, update(socket, :show_password, &(!&1))}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-[#F8FAFC] text-[#0F172A] font-sans antialiased">

      <!-- TOP NAVIGATION -->
      <header class="border-b border-[#E2E8F0] bg-white shadow-sm">
        <div class="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
          <div class="flex items-center gap-3">
            <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-[#112250] text-white font-bold text-xs">
              CS
            </div>
            <div>
              <p class="text-[10px] font-mono font-bold uppercase tracking-wider text-[#64748B]">
                Customer Support
              </p>
              <h1 class="text-sm font-bold text-[#0F172A]">Staff Management</h1>
            </div>
          </div>

          <.link
            navigate={~p"/support/manager/staff"}
            class="inline-flex items-center gap-1.5 rounded-lg border border-[#E2E8F0] bg-white px-3.5 py-1.5 text-xs font-semibold text-[#475569] shadow-sm transition hover:bg-[#F8FAFC]"
          >
            ← Back to Staff Directory
          </.link>
        </div>
      </header>

      <!-- MAIN LAYOUT -->
      <main class="mx-auto max-w-7xl px-6 py-8">

        <div class="grid grid-cols-1 gap-8 lg:grid-cols-12">

          <!-- LEFT: FORM SECTION (7 COLS) -->
          <div class="lg:col-span-7 space-y-6">

            <div>
              <h2 class="text-2xl font-extrabold tracking-tight text-[#0F172A]">
                Create Support Staff
              </h2>
              <p class="mt-1 text-xs text-[#64748B]">
                Set up an account and assign initial credentials for new team members.
              </p>
            </div>

            <!-- FLASH NOTIFICATIONS -->
            <div>
              <.flash kind={:info} flash={@flash} />
              <.flash kind={:error} flash={@flash} />
            </div>

            <div class="rounded-xl border border-[#E2E8F0] bg-white p-6 shadow-sm">
              <.form
                for={@form}
                phx-change="validate"
                phx-submit="create_staff"
                class="space-y-5"
              >

                <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                  <!-- STAFF IDENTIFIER -->
                  <div>
                    <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-[#475569]">
                      Staff ID <span class="text-red-500">*</span>
                    </label>
                    <.input
                      field={@form[:staff_identifier]}
                      type="text"
                      placeholder="e.g. STF-012"
                      class="w-full rounded-lg border border-[#CBD5E1] bg-white px-3 py-2 text-xs font-mono text-[#0F172A] focus:border-[#112250] focus:ring-1 focus:ring-[#112250]"
                    />
                  </div>

                  <!-- FULL NAME -->
                  <div>
                    <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-[#475569]">
                      Full Name <span class="text-red-500">*</span>
                    </label>
                    <.input
                      field={@form[:name]}
                      type="text"
                      placeholder="e.g. Alex Morgan"
                      class="w-full rounded-lg border border-[#CBD5E1] bg-white px-3 py-2 text-xs text-[#0F172A] focus:border-[#112250] focus:ring-1 focus:ring-[#112250]"
                    />
                  </div>
                </div>

                <!-- EMAIL -->
                <div>
                  <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-[#475569]">
                    Email Address <span class="text-red-500">*</span>
                  </label>
                  <.input
                    field={@form[:email]}
                    type="email"
                    placeholder="alex.morgan@company.com"
                    class="w-full rounded-lg border border-[#CBD5E1] bg-white px-3 py-2 text-xs text-[#0F172A] focus:border-[#112250] focus:ring-1 focus:ring-[#112250]"
                  />
                </div>

                <!-- PASSWORD -->
                <div>
                <div class="flex items-center justify-between mb-1">
                  <label class="block text-xs font-semibold uppercase tracking-wider text-[#475569]">
                    Initial Password <span class="text-red-500">*</span>
                  </label>

                  <div class="flex items-center gap-3">
                    <button
                      type="button"
                      phx-click="toggle_password_visibility"
                      class="text-[11px] font-semibold text-[#112250] hover:underline"
                    >
                      <%= if @show_password do %>
                        Hide
                      <% else %>
                        Show
                      <% end %>
                    </button>

                    <button
                      type="button"
                      phx-click="generate_password"
                      class="text-[11px] font-semibold text-[#112250] hover:underline"
                    >
                      ⚡ Auto-Generate
                    </button>
                  </div>
                </div>
                  <.input
                  field={@form[:password]}
                  type={if @show_password, do: "text", else: "password"}
                  placeholder="At least 8 characters"
                  class="w-full rounded-lg border border-[#CBD5E1] bg-white px-3 py-2 text-xs font-mono text-[#0F172A] focus:border-[#112250] focus:ring-1 focus:ring-[#112250]"
                />
                </div>

                <!-- ACTIONS -->
                <div class="flex items-center justify-end gap-3 pt-4 border-t border-[#F1F5F9]">
                  <.link
                    navigate={~p"/support/manager/staff"}
                    class="rounded-lg border border-[#E2E8F0] bg-white px-4 py-2 text-xs font-semibold text-[#475569] hover:bg-[#F8FAFC]"
                  >
                    Cancel
                  </.link>
                  <button
                    type="submit"
                    class="rounded-lg bg-[#112250] px-5 py-2 text-xs font-semibold uppercase tracking-wider text-white hover:bg-[#1A3268]"
                  >
                    Create Staff Member
                  </button>
                </div>

              </.form>
            </div>

          </div>

          <!-- RIGHT: OPERATIONAL SIDEBAR (5 COLS) -->
          <div class="lg:col-span-5 space-y-6">

            <!-- METRICS SUMMARY -->
            <div class="grid grid-cols-2 gap-4">
              <div class="rounded-xl border border-[#E2E8F0] bg-white p-4 shadow-sm">
                <p class="text-[11px] font-semibold uppercase text-[#64748B]">Active Staff</p>
                <p class="mt-2 text-2xl font-black text-[#0F172A]"><%= @active_staff_count %></p>
                <p class="mt-1 text-[10px] text-emerald-600 font-semibold">● All systems nominal</p>
              </div>


            </div>

            <!-- RECENTLY ONBOARDED STAFF -->
            <div class="rounded-xl border border-[#E2E8F0] bg-white p-6 shadow-sm">
              <h3 class="text-xs font-bold uppercase tracking-wider text-[#475569] mb-4">
                Recently Onboarded
              </h3>

              <div class="divide-y divide-[#F1F5F9]">
                <%= for staff <- @recent_additions do %>
                  <div class="flex items-center justify-between py-3 first:pt-0 last:pb-0">
                    <div class="flex items-center gap-3">
                      <div class="flex h-8 w-8 items-center justify-center rounded-full bg-[#F1F5F9] font-bold text-xs text-[#334155]">
                        <%= String.slice(staff.name, 0..0) %>
                      </div>
                      <div>
                        <p class="text-xs font-bold text-[#0F172A]"><%= staff.name %></p>
                        <p class="text-[10px] font-mono text-[#64748B]"><%= staff.staff_identifier %></p>
                      </div>
                    </div>
                    <span class="text-[10px] text-[#94A3B8]"><%= staff.inserted_at %></span>
                  </div>
                <% end %>
              </div>
            </div>

          </div>

        </div>

      </main>
    </div>
    """
  end
end

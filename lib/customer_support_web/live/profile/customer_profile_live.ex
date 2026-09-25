defmodule CustomerSupportWeb.CustomerProfileLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Accounts
  alias CustomerSupport.Requests

  def mount(_params, session, socket) do
    customer_id = session["customer_id"]
    customer = Accounts.get_customer(customer_id)

    requests = Requests.list_requests_by_customer(customer_id)

    {:ok,
    assign(socket,
      customer: customer,
      requests: requests
    )}
  end

  def handle_event("update_profile", %{"customer" => params}, socket) do
    case Accounts.update_customer(socket.assigns.customer, params) do
      {:ok, customer} ->
        {:noreply,
         socket
         |> assign(:customer, customer)
         |> put_flash(:info, "Profile updated successfully.")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto space-y-8 py-4 font-sans">

      <!-- PAGE HEADER BANNER -->
      <div class="relative overflow-hidden rounded-3xl bg-[#112250] p-8 md:p-10 text-[#F5F0E9] shadow-xl">
        <!-- Ambient Background Glows -->
        <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
        <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

        <div class="relative z-10 flex flex-col sm:flex-row sm:items-center justify-between gap-6">
          <div>
            <.link
              navigate={~p"/dashboard"}
              class="inline-flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-[#E0C58F] hover:text-[#F5F0E9] transition-colors mb-3"
            >
              <.icon name="hero-arrow-left" class="size-4" />
              Dashboard
            </.link>

            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tight text-[#F5F0E9]">
              My Profile
            </h1>

            <p class="mt-2 text-[#D9CBC2] text-sm md:text-base">
              View and manage your personal account information and credentials.
            </p>
          </div>



        </div>
      </div>

      <!-- ACCOUNT INFORMATION CARD -->
      <div class="overflow-hidden rounded-3xl border border-[#D9CBC2]/60 bg-white shadow-sm">

        <!-- CARD HEADER -->
        <div class="border-b border-[#D9CBC2]/40 bg-[#F5F0E9]/60 px-6 py-5 sm:px-8">
          <div class="flex items-center gap-4">
            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-[#112250] text-[#E0C58F] shadow-md">
              <.icon name="hero-user" class="size-6" />
            </div>

            <div>
              <h2 class="text-lg font-bold text-[#112250]">
                Account Information
              </h2>
              <p class="text-xs text-[#3C5070]">
                Your personal details registered with the system.
              </p>
            </div>
          </div>
        </div>

        <!-- INFORMATION DETAILS LIST -->
        <div class="divide-y divide-[#D9CBC2]/30">

          <!-- NAME -->
          <div class="flex items-start gap-4 px-6 py-5 sm:px-8 hover:bg-[#F5F0E9]/20 transition-colors">
            <div class="mt-1 text-[#3C5070]">
              <.icon name="hero-user-circle" class="size-5" />
            </div>
            <div class="flex-1">
              <p class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                Full Name
              </p>
              <p class="mt-1 text-base font-semibold text-[#112250]">
                <%= @customer.name %>
              </p>
            </div>
          </div>

          <!-- EMAIL -->
          <div class="flex items-start gap-4 px-6 py-5 sm:px-8 hover:bg-[#F5F0E9]/20 transition-colors">
            <div class="mt-1 text-[#3C5070]">
              <.icon name="hero-envelope" class="size-5" />
            </div>
            <div class="flex-1">
              <p class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                Email Address
              </p>
              <p class="mt-1 text-base font-semibold text-[#112250]">
                <%= @customer.email %>
              </p>
            </div>
          </div>

          <!-- PHONE -->
          <div class="flex items-start gap-4 px-6 py-5 sm:px-8 hover:bg-[#F5F0E9]/20 transition-colors">
            <div class="mt-1 text-[#3C5070]">
              <.icon name="hero-phone" class="size-5" />
            </div>
            <div class="flex-1">
              <p class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                Phone Number
              </p>
              <p class="mt-1 text-base font-semibold text-[#112250]">
                <%= @customer.phone %>
              </p>
            </div>
          </div>

          <!-- PASSWORD -->
          <div class="flex flex-col gap-4 px-6 py-5 sm:flex-row sm:items-center sm:justify-between sm:px-8 hover:bg-[#F5F0E9]/20 transition-colors">
            <div class="flex items-start gap-4">
              <div class="mt-1 text-[#3C5070]">
                <.icon name="hero-key" class="size-5" />
              </div>
              <div>
                <p class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                  Password
                </p>
                <p class="mt-1 text-base font-semibold tracking-widest text-[#112250]">
                  ••••••••••••
                </p>
              </div>
            </div>

            <.link
              navigate={~p"/change-password"}
              class="inline-flex items-center gap-2 rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/80 px-4 py-2.5 text-xs font-bold text-[#112250] hover:bg-[#D9CBC2]/50 active:scale-[0.98] transition-all duration-200 self-start sm:self-auto"
            >
              <.icon name="hero-lock-closed" class="size-4" />
              Change Password
            </.link>
          </div>

        </div>

        <!-- FOOTER BAR -->
        <div class="border-t border-[#D9CBC2]/40 bg-[#F5F0E9]/30 px-6 py-4 sm:px-8 flex justify-end">
          <.link
            navigate={~p"/profile/edit"}
            class="inline-flex items-center gap-2 rounded-xl bg-[#E0C58F] px-6 py-3 font-bold text-sm text-[#112250] shadow-sm hover:bg-[#D9CBC2] active:scale-[0.98] transition-all duration-200"
          >
            <.icon name="hero-pencil-square" class="size-4 stroke-[2.5]" />
            Edit Profile
          </.link>
        </div>

      </div>

      <!-- SYSTEM IDENTIFIER CARD -->
      <div class="rounded-3xl border border-[#D9CBC2]/60 bg-white p-6 sm:p-8 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <p class="text-xs font-bold uppercase tracking-wider text-[#3C5070]">
            Unique Customer ID
          </p>
          <p class="mt-1 font-mono text-sm font-semibold text-[#112250] break-all">
            <%= @customer.customer_id %>
          </p>
        </div>

        <div class="inline-flex items-center gap-2 self-start sm:self-auto px-3 py-1.5 rounded-xl bg-[#F5F0E9] border border-[#D9CBC2]/60 text-xs font-medium text-[#3C5070]">
          <.icon name="hero-fingerprint" class="size-4 text-[#112250]" />
          Account Reference
        </div>
      </div>

    </div>
    """
  end
end

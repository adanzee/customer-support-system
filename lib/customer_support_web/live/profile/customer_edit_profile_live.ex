defmodule CustomerSupportWeb.CustomerEditProfileLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Accounts

  def mount(_params, session, socket) do
    customer_id = session["customer_id"]
    customer = Accounts.get_customer(customer_id)

    {:ok, assign(socket, :customer, customer)}
  end

  def handle_event("update_profile", %{"customer" => params}, socket) do
    case Accounts.update_customer(socket.assigns.customer, params) do
      {:ok, customer} ->
        {:noreply,
         socket
         |> assign(:customer, customer)
         |> put_flash(:info, "Profile updated successfully.")
         |> push_navigate(to: ~p"/profile")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto space-y-8 py-4 font-sans">

      <!-- PAGE HEADER BANNER -->
      <div class="relative overflow-hidden rounded-3xl bg-[#112250] p-8 md:p-10 text-[#F5F0E9] shadow-xl">
        <!-- Ambient Glow Effects -->
        <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
        <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

        <div class="relative z-10">
          <.link
            navigate={~p"/profile/edit"}
            class="inline-flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-[#E0C58F] hover:text-[#F5F0E9] transition-colors mb-4"
          >
            <.icon name="hero-arrow-left" class="size-4" />
            Back to Profile
          </.link>

          <h1 class="text-3xl md:text-4xl font-extrabold tracking-tight text-[#F5F0E9]">
            Edit Profile
          </h1>

          <p class="mt-2 text-[#D9CBC2] text-sm md:text-base max-w-2xl">
            Update your personal details and contact information associated with your account.
          </p>
        </div>
      </div>

      <!-- EDIT FORM CARD -->
      <div class="overflow-hidden rounded-3xl border border-[#D9CBC2]/60 bg-white shadow-sm">

        <!-- CARD HEADER -->
        <div class="border-b border-[#D9CBC2]/40 bg-[#F5F0E9]/60 px-6 py-5 sm:px-8">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-[#112250] text-[#E0C58F] shadow-sm">
              <.icon name="hero-user" class="size-5" />
            </div>
            <div>
              <h2 class="text-lg font-bold text-[#112250]">
                Personal Information
              </h2>
              <p class="text-xs text-[#3C5070]">
                Keep your contact details up to date.
              </p>
            </div>
          </div>
        </div>

        <!-- CARD BODY & FORM -->
        <div class="p-6 sm:p-8">
          <form phx-submit="update_profile" class="space-y-6">

            <!-- NAME FIELD -->
            <div class="space-y-2">
              <label for="customer_name" class="block text-sm font-bold text-[#112250]">
                Full Name <span class="text-rose-500">*</span>
              </label>

              <div class="relative">
                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#3C5070]">
                  <.icon name="hero-user" class="size-4" />
                </div>

                <input
                  id="customer_name"
                  type="text"
                  name="customer[name]"
                  value={@customer.name}
                  required
                  placeholder="e.g. Jane Doe"
                  class="w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 pl-11 pr-4 py-3.5 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
                />
              </div>
            </div>

            <!-- EMAIL FIELD -->
            <div class="space-y-2">
              <label for="customer_email" class="block text-sm font-bold text-[#112250]">
                Email Address <span class="text-rose-500">*</span>
              </label>

              <div class="relative">
                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#3C5070]">
                  <.icon name="hero-envelope" class="size-4" />
                </div>

                <input
                  id="customer_email"
                  type="email"
                  name="customer[email]"
                  value={@customer.email}
                  required
                  placeholder="e.g. name@example.com"
                  class="w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 pl-11 pr-4 py-3.5 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
                />
              </div>
            </div>

            <!-- PHONE FIELD -->
            <div class="space-y-2">
              <label for="customer_phone" class="block text-sm font-bold text-[#112250]">
                Phone Number <span class="text-rose-500">*</span>
              </label>

              <div class="relative">
                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#3C5070]">
                  <.icon name="hero-phone" class="size-4" />
                </div>

                <input
                  id="customer_phone"
                  type="tel"
                  name="customer[phone]"
                  value={@customer.phone}
                  required
                  placeholder="e.g. +1 (555) 000-0000"
                  class="w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 pl-11 pr-4 py-3.5 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
                />
              </div>
            </div>

            <!-- FOOTER ACTIONS -->
            <div class="flex flex-col-reverse sm:flex-row sm:items-center sm:justify-end gap-3 pt-6 border-t border-[#D9CBC2]/40">
              <.link
                navigate={~p"/profile"}
                class="inline-flex items-center justify-center gap-2 rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/80 px-6 py-3 font-semibold text-sm text-[#112250] hover:bg-[#D9CBC2]/50 active:scale-[0.98] transition-all duration-200"
              >
                Cancel
              </.link>

              <button
                type="submit"
                class="inline-flex items-center justify-center gap-2 rounded-xl bg-[#E0C58F] px-8 py-3.5 font-bold text-sm text-[#112250] shadow-md hover:bg-[#D9CBC2] active:scale-[0.98] transition-all duration-200"
              >
                <.icon name="hero-check" class="size-4 stroke-[2.5]" />
                Save Changes
              </button>
            </div>

          </form>
        </div>

      </div>

    </div>
    """
  end
end

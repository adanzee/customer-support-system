defmodule CustomerSupportWeb.RequestNewLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Mailer
  alias CustomerSupport.Mailers.CustomerMailer
  alias CustomerSupport.Accounts

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

def handle_event("create_request", %{"request" => request_params}, socket) do
  customer = socket.assigns.customer
  customer_id = customer.customer_id

  attrs = Map.put(request_params, "customer_id", customer_id)

  case CustomerSupport.Requests.create_request(attrs) do
      {:ok, request} ->
        customer = Accounts.get_customer(customer_id)

        email =
          CustomerMailer.request_submitted_email(customer, request)

        Mailer.deliver(email)

        {:noreply,
         socket
         |> put_flash(:info, "Request created successfully.")
         |> push_navigate(to: ~p"/dashboard")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-4xl mx-auto space-y-8 py-4 font-sans">

        <!-- PAGE HEADER BANNER -->
        <div class="relative overflow-hidden rounded-3xl bg-[#112250] p-8 md:p-10 text-[#F5F0E9] shadow-xl">
          <!-- Decorative Glows -->
          <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
          <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

          <div class="relative z-10">
            <.link
              navigate={~p"/requests"}
              class="inline-flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-[#E0C58F] hover:text-[#F5F0E9] transition-colors mb-4"
            >
              <.icon name="hero-arrow-left" class="size-4" />
              Back to Requests
            </.link>

            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tight text-[#F5F0E9]">
              Submit a Support Request
            </h1>

            <p class="mt-2 text-[#D9CBC2] text-sm md:text-base max-w-2xl">
              Tell us about the issue you are experiencing. Our dedicated engineering support team will review your ticket promptly.
            </p>
          </div>
        </div>

        <!-- FORM CARD CONTAINER -->
        <div class="rounded-3xl border border-[#D9CBC2]/60 bg-white p-6 sm:p-10 shadow-sm">
          <form phx-submit="create_request" class="space-y-8">

            <!-- TITLE FIELD -->
            <div class="space-y-2">
              <div class="flex items-center gap-2">
                <.icon name="hero-pencil-square" class="size-4 text-[#112250]" />
                <label for="request_title" class="block text-sm font-bold text-[#112250]">
                  Request Title <span class="text-rose-500">*</span>
                </label>
              </div>

              <p class="text-xs text-[#3C5070]">
                Provide a clear, brief summary of the issue.
              </p>

              <input
                id="request_title"
                type="text"
                name="request[title]"
                required
                placeholder="e.g. Unable to access my dashboard"
                class="w-full rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 px-4 py-3.5 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
              />
            </div>

            <!-- CATEGORY FIELD -->
            <div class="space-y-2">
              <div class="flex items-center gap-2">
                <.icon name="hero-tag" class="size-4 text-[#112250]" />
                <label for="request_category" class="block text-sm font-bold text-[#112250]">
                  Category <span class="text-rose-500">*</span>
                </label>
              </div>

              <p class="text-xs text-[#3C5070]">
                Select the classification that best fits your issue.
              </p>

              <div class="relative group">
                <!-- Left Decorative Icon -->
                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#3C5070] group-focus-within:text-[#112250] transition-colors">
                  <.icon name="hero-tag" class="size-4" />
                </div>

                <select
                  id="request_category"
                  name="request[category]"
                  required
                  class="w-full appearance-none rounded-2xl border border-[#D9CBC2]/80 bg-[#F5F0E9]/50 pl-11 pr-11 py-3.5 text-sm font-semibold text-[#112250] shadow-sm outline-none transition-all duration-200 cursor-pointer hover:border-[#112250]/40 hover:bg-[#F5F0E9] focus:border-[#112250] focus:bg-white focus:ring-4 focus:ring-[#E0C58F]/30"
                >
                  <option value="" disabled selected class="text-[#3C5070] bg-white py-2">Select a category</option>
                  <option value="Technical" class="text-[#112250] bg-white py-2 font-medium">Technical Issue</option>
                  <option value="Billing" class="text-[#112250] bg-white py-2 font-medium">Billing & Subscription</option>
                  <option value="Account" class="text-[#112250] bg-white py-2 font-medium">Account Access</option>
                  <option value="General" class="text-[#112250] bg-white py-2 font-medium">General Inquiry</option>
                  <option value="Other" class="text-[#112250] bg-white py-2 font-medium">Other</option>
                </select>

                <!-- Right Custom Chevron Pill -->
                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                  <div class="flex items-center justify-center h-8 w-8 rounded-xl bg-[#112250]/5 group-hover:bg-[#112250]/10 text-[#3C5070] transition-colors">
                    <.icon name="hero-chevron-down" class="size-4 stroke-[2.5]" />
                  </div>
                </div>
              </div>
            </div>

            <!-- DESCRIPTION FIELD -->
            <div class="space-y-2">
              <div class="flex items-center gap-2">
                <.icon name="hero-document-text" class="size-4 text-[#112250]" />
                <label for="request_description" class="block text-sm font-bold text-[#112250]">
                  Detailed Description <span class="text-rose-500">*</span>
                </label>
              </div>

              <p class="text-xs text-[#3C5070]">
                Include relevant context, steps to reproduce, or error codes to help us resolve this faster.
              </p>

              <textarea
                id="request_description"
                name="request[description]"
                rows="6"
                required
                placeholder="Describe what happened, what you expected, and any troubleshooting steps you've already taken..."
                class="w-full resize-y rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/40 p-4 text-sm text-[#112250] placeholder-[#3C5070]/50 shadow-inner outline-none transition-all duration-200 focus:border-[#112250] focus:bg-white focus:ring-2 focus:ring-[#E0C58F]"
              ></textarea>
            </div>

            <!-- FOOTER ACTIONS -->
            <div class="flex flex-col-reverse sm:flex-row sm:items-center sm:justify-end gap-3 pt-6 border-t border-[#D9CBC2]/40">
              <.link
                navigate={~p"/requests"}
                class="inline-flex items-center justify-center gap-2 rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/80 px-6 py-3 font-semibold text-sm text-[#112250] hover:bg-[#D9CBC2]/50 active:scale-[0.98] transition-all duration-200"
              >
                Cancel
              </.link>

              <button
                type="submit"
                class="inline-flex items-center justify-center gap-2 rounded-xl bg-[#E0C58F] px-8 py-3.5 font-bold text-sm text-[#112250] shadow-md hover:bg-[#D9CBC2] active:scale-[0.98] transition-all duration-200"
              >
                <.icon name="hero-paper-airplane" class="size-4 stroke-[2.5]" />
                Submit Request
              </button>
            </div>

          </form>
        </div>

      </div>
    """
  end
end

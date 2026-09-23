defmodule CustomerSupportWeb.RequestNewLive do
  use CustomerSupportWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("submit_request", params, socket) do
    attrs = %{
      title: params["title"],
      category: params["category"],
      description: params["description"],
      status: "Open",
      priority: nil,
      customer_id: 1
    }

    case CustomerSupport.Requests.create_request(attrs) do
      {:ok, request} ->
        IO.inspect(request, label: "Created Request")

        {:noreply,
        socket
        |> put_flash(:info, "Request submitted successfully.")
        |> push_navigate(to: "/")}

      {:error, changeset} ->
        IO.inspect(changeset, label: "Request Error")

        {:noreply, socket}
    end
  end



  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">

      <!-- Navigation -->
      <header class="border-b border-gray-200 bg-white">
        <div class="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">

          <a
            href="/"
            class="text-xl font-bold text-gray-900"
          >
            Customer Support
          </a>

          <div class="flex items-center gap-4">
            <a
              href="/"
              class="text-sm font-medium text-gray-600 hover:text-gray-900"
            >
              Dashboard
            </a>

            <a
              href="/profile"
              class="text-sm font-medium text-gray-600 hover:text-gray-900"
            >
              Profile
            </a>
          </div>

        </div>
      </header>

      <!-- Main -->
      <main class="mx-auto max-w-3xl px-6 py-10">

        <!-- Page Header -->
        <div class="mb-8">
          <h1 class="text-2xl font-bold text-gray-900">
            Submit a Support Request
          </h1>

          <p class="mt-1 text-sm text-gray-500">
            Tell us about the issue you're experiencing.
          </p>
        </div>

        <!-- Form -->
        <div class="rounded-xl border border-gray-200 bg-white p-8 shadow-sm">

          <form phx-submit="submit_request">

            <!-- Issue Title -->
            <div class="mb-6">
              <label
                for="title"
                class="block text-sm font-medium text-gray-700"
              >
                Issue Title
              </label>

              <input
                id="title"
                name="title"
                type="text"
                class="mt-2 block text-gray-900  w-full rounded-lg border border-gray-300 px-4 py-3 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            <!-- Category -->
            <div class="mb-6">
              <label
                for="category"
                class="block text-sm font-medium text-gray-700"
              >
                Category
              </label>

              <select
                id="category"
                name="category"
                class="mt-2 block w-full text-gray-800 rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Select a category</option>
                <option value="technical">Technical Issue</option>
                <option value="billing">Billing</option>
                <option value="account">Account</option>
                <option value="feature_request">Feature Request</option>
                <option value="other">Other</option>
              </select>
            </div>

            <!-- Description -->
            <div class="mb-8">
              <label
                for="description"
                class="block text-sm font-medium text-gray-700"
              >
                Description
              </label>

              <textarea
                id="description"
                name="description"
                rows="7"
                placeholder="Describe your issue in detail..."
                class="mt-2 block w-full resize-y text-gray-800 rounded-lg border border-gray-300 px-4 py-3 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
              ></textarea>
            </div>

            <!-- Actions -->
            <div class="flex items-center justify-end gap-3">
              <a
                href="/"
                class="rounded-lg border border-gray-300 px-5 py-3 text-sm font-medium text-gray-700 hover:bg-gray-50"
              >
                Cancel
              </a>

              <button
                type="submit"
                class="rounded-lg bg-blue-600 px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
              >
                Submit Request
              </button>
            </div>

          </form>

        </div>
      </main>
    </div>
    """
  end

end

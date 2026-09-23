defmodule CustomerSupportWeb.CustomerPortalLive do
  use CustomerSupportWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">

      <!-- Navigation -->
      <header class="border-b border-gray-200 bg-white">
        <div class="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">

          <div class="flex items-center gap-8">
            <a
              href="/"
              class="text-xl font-bold text-gray-900"
            >
              Customer Support
            </a>

            <nav class="hidden items-center gap-6 md:flex">
              <a
                href="/"
                class="text-sm font-medium text-blue-600"
              >
                Dashboard
              </a>

              <a
                href="/requests"
                class="text-sm font-medium text-gray-600 hover:text-gray-900"
              >
                My Requests
              </a>
            </nav>
          </div>

          <div class="flex items-center gap-4">
            <a
              href="/profile"
              class="text-sm font-medium text-gray-600 hover:text-gray-900"
            >
              Profile
            </a>

            <a
              href="/logout"
              class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              Logout
            </a>
          </div>

        </div>
      </header>

      <!-- Main -->
      <main class="mx-auto max-w-7xl px-6 py-10">

        <!-- Page Header -->
        <div class="mb-8 flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">
              Customer Dashboard
            </h1>

            <p class="mt-1 text-sm text-gray-500">
              Manage and track your support requests.
            </p>
          </div>

          <!-- New Request Button -->
          <a
            href="/requests/new"
            class="inline-flex items-center gap-2 rounded-lg bg-blue-600 px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
          >
            <span class="text-lg leading-none">+</span>
            New Request
          </a>
        </div>

        <!-- Dashboard Content -->
        <div class="rounded-xl border border-gray-200 bg-white p-8 shadow-sm">
          <h2 class="text-lg font-semibold text-gray-900">
            Welcome to your support portal
          </h2>

          <p class="mt-2 text-sm text-gray-500">
            Your support requests and updates will appear here.
          </p>
        </div>

      </main>
    </div>
    """
  end
end

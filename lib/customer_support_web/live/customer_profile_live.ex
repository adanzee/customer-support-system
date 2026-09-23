defmodule CustomerSupportWeb.CustomerProfileLive do
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
                class="text-sm font-medium text-gray-600 hover:text-gray-900"
              >
                Dashboard
              </a>

              <a
                href="/requests"
                class="text-sm font-medium text-gray-600 hover:text-gray-900"
              >
                My Requests
              </a>

              <a
                href="/profile"
                class="text-sm font-medium text-blue-600"
              >
                Profile
              </a>
            </nav>
          </div>

          <a
            href="/logout"
            class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Logout
          </a>

        </div>
      </header>

      <!-- Main -->
      <main class="mx-auto max-w-4xl px-6 py-10">

        <!-- Page Header -->
        <div class="mb-8">
          <h1 class="text-2xl font-bold text-gray-900">
            Profile
          </h1>

          <p class="mt-1 text-sm text-gray-500">
            View and manage your account information.
          </p>
        </div>

        <!-- Profile Card -->
        <div class="rounded-xl border border-gray-200 bg-white shadow-sm">

          <!-- Card Header -->
          <div class="border-b border-gray-200 px-8 py-6">
            <h2 class="text-lg font-semibold text-gray-900">
              Personal Information
            </h2>

            <p class="mt-1 text-sm text-gray-500">
              Your customer account information.
            </p>
          </div>

          <!-- Profile Information -->
          <div class="px-8 py-6">

            <div class="grid grid-cols-1 gap-6 md:grid-cols-2">

              <!-- Full Name -->
              <div>
                <label class="block text-sm font-medium text-gray-500">
                  Full Name
                </label>

                <div class="mt-2 rounded-lg border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-900">
                  Customer Name
                </div>
              </div>

              <!-- Email -->
              <div>
                <label class="block text-sm font-medium text-gray-500">
                  Email Address
                </label>

                <div class="mt-2 rounded-lg border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-900">
                  customer@example.com
                </div>
              </div>

              <!-- Phone -->
              <div>
                <label class="block text-sm font-medium text-gray-500">
                  Phone Number
                </label>

                <div class="mt-2 rounded-lg border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-900">
                  +92 300 1234567
                </div>
              </div>

              <!-- Account Status -->
              <div>
                <label class="block text-sm font-medium text-gray-500">
                  Account Status
                </label>

                <div class="mt-2 flex items-center gap-2 rounded-lg border border-gray-200 bg-gray-50 px-4 py-3 text-sm">
                  <span class="h-2.5 w-2.5 rounded-full bg-green-500"></span>
                  <span class="font-medium text-gray-900">
                    Active
                  </span>
                </div>
              </div>

            </div>

          </div>

          <!-- Card Footer -->
          <div class="flex justify-end border-t border-gray-200 px-8 py-5">
            <button
              type="button"
              class="rounded-lg bg-blue-600 px-5 py-3 text-sm font-semibold text-white shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              Edit Profile
            </button>
          </div>

        </div>

        <!-- Security Card -->
        <div class="mt-6 rounded-xl border border-gray-200 bg-white shadow-sm">

          <div class="px-8 py-6">
            <h2 class="text-lg font-semibold text-gray-900">
              Security
            </h2>

            <p class="mt-1 text-sm text-gray-500">
              Manage your account security settings.
            </p>
          </div>

          <div class="flex items-center justify-between border-t border-gray-200 px-8 py-5">
            <div>
              <p class="text-sm font-medium text-gray-900">
                Password
              </p>

              <p class="mt-1 text-sm text-gray-500">
                Change your account password.
              </p>
            </div>

            <button
              type="button"
              class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              Change Password
            </button>
          </div>

        </div>

      </main>
    </div>
    """
  end
end

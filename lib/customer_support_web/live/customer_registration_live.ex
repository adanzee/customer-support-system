defmodule CustomerSupportWeb.CustomerRegistrationLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Accounts
  alias CustomerSupport.Accounts.Customer

  def mount(_params, _session, socket) do
    changeset = Customer.registration_changeset(%Customer{}, %{})

    {:ok, assign(socket, form: to_form(changeset))}
  end

  def handle_event("register", %{"customer" => customer_params}, socket) do
    case Accounts.register_customer(customer_params) do
      {:ok, _customer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully.")
         |> push_navigate(to: ~p"/")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50 flex items-center justify-center px-4 py-12">
      <div class="w-full max-w-md">
        <!-- Header -->
        <div class="text-center mb-8">
          <div class="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-xl bg-blue-600 text-white shadow-sm">
            <span class="text-lg font-bold">CS</span>
          </div>

          <h1 class="text-3xl font-bold tracking-tight text-gray-900">
            Create your account
          </h1>

          <p class="mt-2 text-sm text-gray-500">
            Create an account to submit and manage your support requests.
          </p>
        </div>

        <!-- Registration Card -->
        <div class="rounded-2xl border border-gray-200 bg-white p-8 shadow-sm">

          <.form
            for={@form}
            id="registration-form"
            action={~p"/register"}
            method="post"
            class="space-y-5"
          >


            <!-- Full Name -->
            <div>
              <label
                for={@form[:full_name].id}
                class="mb-2 block text-sm font-medium text-gray-700"
              >
                Full Name
              </label>

              <.input
                field={@form[:full_name]}
                type="text"
                placeholder="Enter your full name"
                class="w-full rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
              />
            </div>

            <!-- Email -->
            <div>
              <label
                for={@form[:email].id}
                class="mb-2 block text-sm font-medium text-gray-700"
              >
                Email Address
              </label>

              <.input
                field={@form[:email]}
                type="email"
                placeholder="you@example.com"
                class="w-full rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
              />
            </div>

            <!-- Phone -->
            <div>
              <label
                for={@form[:phone_number].id}
                class="mb-2 block text-sm font-medium text-gray-700"
              >
                Phone Number
              </label>

              <.input
                field={@form[:phone_number]}
                type="tel"
                placeholder="Enter your phone number"
                class="w-full rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
              />
            </div>

            <!-- Password -->
            <div>
              <label
                for={@form[:password].id}
                class="mb-2 block text-sm font-medium text-gray-700"
              >
                Password
              </label>

              <.input
                field={@form[:password]}
                type="password"
                placeholder="Create a password"
                class="w-full rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
              />

              <p class="mt-1.5 text-xs text-gray-500">
                Must be at least 8 characters.
              </p>
            </div>

            <!-- Confirm Password -->
            <div>
              <label
                for={@form[:password_confirmation].id}
                class="mb-2 block text-sm font-medium text-gray-700"
              >
                Confirm Password
              </label>

              <.input
                field={@form[:password_confirmation]}
                type="password"
                placeholder="Confirm your password"
                class="w-full rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
              />
            </div>

            <!-- Submit -->
            <button
              type="submit"
              class="w-full rounded-lg bg-blue-600 px-4 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              Create Account
            </button>
          </.form>

          <!-- Login -->
          <div class="mt-6 border-t border-gray-100 pt-6 text-center">
            <p class="text-sm text-gray-500">
              Already have an account?
              <a
                href="/login"
                class="font-semibold text-blue-600 hover:text-blue-700"
              >
                Sign in
              </a>
            </p>
          </div>
        </div>

        <!-- Footer -->
        <p class="mt-6 text-center text-xs text-gray-400">
          Your account information is securely protected.
        </p>
      </div>
    </div>


    """
  end

end

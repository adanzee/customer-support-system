defmodule CustomerSupportWeb.CustomerLoginLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Accounts


  def mount(_params, _session, socket) do
    form =
      to_form(%{
        "email" => "",
        "password" => ""
      })

    {:ok,
    socket
    |> assign(:form, form)
    |> assign(:current_customer, nil)}
  end




  def handle_event("login", %{"email" => email, "password" => password}, socket) do
    case Accounts.authenticate_customer(email, password) do
      {:ok, customer} ->
        IO.inspect(customer, label: "Authenticated Customer")

        {:noreply,
        socket
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: ~p"/login/session/#{customer.id}")}

      {:error, :invalid_credentials} ->
        form =
          to_form(
            %{
              "email" => email,
              "password" => ""
            },
            errors: [login: {"Invalid email or password", []}]
          )

        {:noreply, assign(socket, form: form)}
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
            Welcome back
          </h1>

          <p class="mt-2 text-sm text-gray-500">
            Sign in to access your customer support portal.
          </p>
        </div>

        <!-- Login Card -->
        <div class="rounded-2xl border border-gray-200 bg-white p-8 shadow-sm">

          <.form
            for={@form}
            id="login-form"
            phx-submit="login"
            class="space-y-5"
          >

            <!-- Error -->
            <%= if @form.errors != [] do %>
              <div class="rounded-lg border border-red-200 bg-red-50 px-4 py-3">
                <p class="text-sm text-red-600">
                  Invalid email address or password.
                </p>
              </div>
            <% end %>

            <!-- Email -->
            <div>
              <label
                for="email"
                class="mb-2 block text-sm font-medium text-gray-700"
              >
                Email Address
              </label>

              <input
                id="email"
                name="email"
                type="email"
                value={@form.params["email"]}
                placeholder="you@example.com"
                autocomplete="email"
                required
                class="w-full rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
              />
            </div>

            <!-- Password -->
            <div>
              <div class="mb-2 flex items-center justify-between">
                <label
                  for="password"
                  class="block text-sm font-medium text-gray-700"
                >
                  Password
                </label>

                <a
                  href="/forgot-password"
                  class="text-xs font-medium text-blue-600 hover:text-blue-700"
                >
                  Forgot password?
                </a>
              </div>

              <input
                id="password"
                name="password"
                type="password"
                placeholder="Enter your password"
                autocomplete="current-password"
                required
                class="w-full rounded-lg border border-gray-300 bg-white px-4 py-3 text-sm text-gray-900 outline-none transition placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
              />
            </div>

            <!-- Submit -->
            <button
              type="submit"
              class="w-full rounded-lg bg-blue-600 px-4 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              Sign In
            </button>
          </.form>

          <!-- Registration -->
          <div class="mt-6 border-t border-gray-100 pt-6 text-center">
            <p class="text-sm text-gray-500">
              Don't have an account?
              <a
                href="/register"
                class="font-semibold text-blue-600 hover:text-blue-700"
              >
                Create an account
              </a>
            </p>
          </div>
        </div>

        <p class="mt-6 text-center text-xs text-gray-400">
          Your account information is securely protected.
        </p>

      </div>
    </div>
    """
  end

end

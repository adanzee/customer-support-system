defmodule CustomerSupportWeb.CustomerRegistrationLive do
use CustomerSupportWeb, :live_view

alias CustomerSupport.Accounts.Customer

  def mount(_params, _session, socket) do
    changeset =
      Customer.registration_changeset(%Customer{}, %{})

    {:ok,
    assign(socket,
      changeset: changeset,
      form: to_form(changeset)
    )}
  end


  def handle_event("validate", %{"customer" => params}, socket) do
    changeset =
      %Customer{}
      |> Customer.registration_changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
    assign(socket,
      changeset: changeset,
      form: to_form(changeset)
    )}
  end

  def handle_event("register", %{"customer" => params}, socket) do
    case CustomerSupport.Accounts.register_customer(params) do
      {:ok, customer} ->
        customer
        |> CustomerSupport.Mailers.CustomerMailer.registration_email()
        |> CustomerSupport.Mailer.deliver()

        {:noreply,
        socket
        |> put_flash(:info, "Account created successfully.")
        |> push_navigate(to: ~p"/login")}

        {:error, changeset} ->
          changeset = Map.put(changeset, :action, :validate)

          {:noreply,
          assign(socket,
            changeset: changeset,
            form: to_form(changeset)
          )}
    end
  end
def render(assigns) do
  ~H"""
  <div class="min-h-screen bg-[#F5F0E9] flex items-center justify-center p-4 sm:p-6 md:p-10 font-sans text-[#112250]">
    <div class="w-full max-w-4xl bg-white rounded-3xl shadow-2xl border border-[#D9CBC2]/50 overflow-hidden grid grid-cols-1 lg:grid-cols-12">

      <!-- Left Panel -->
      <div class="lg:col-span-5 bg-[#112250] p-8 lg:p-12 flex flex-col justify-between relative overflow-hidden text-[#F5F0E9]">

        <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
        <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

        <div class="relative z-10 mb-8 lg:mb-0">
          <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#3C5070]/40 border border-[#E0C58F]/20 text-[#E0C58F] text-xs font-semibold tracking-wider uppercase">
            <span class="w-2 h-2 rounded-full bg-[#E0C58F] animate-pulse"></span>
            Join Us Today
          </div>
        </div>

        <div class="relative z-10 my-auto py-6">
          <h2 class="text-3xl lg:text-4xl font-extrabold text-[#F5F0E9] tracking-tight leading-tight">
            Start your journey with us.
          </h2>

          <p class="mt-4 text-[#D9CBC2] text-sm leading-relaxed">
            Create an account to gain full access to your personalized dashboard,
            manage customer profiles, and stay connected.
          </p>
        </div>

        <div class="relative z-10 pt-6 border-t border-[#3C5070]/60">
          <p class="text-xs text-[#D9CBC2]">
            Already have an account?
            <a
              href="/login"
              class="font-bold text-[#E0C58F] hover:underline ml-1 inline-flex items-center gap-1 group"
            >
              Sign in
              <span class="transition-transform group-hover:translate-x-0.5">&rarr;</span>
            </a>
          </p>
        </div>
      </div>

      <!-- Right Panel -->
      <div class="lg:col-span-7 p-8 lg:p-12 bg-white flex flex-col justify-center">
        <div class="max-w-md mx-auto w-full">

          <div class="mb-8">
            <h1 class="text-2xl lg:text-3xl font-black text-[#112250] tracking-tight">
              Create your account
            </h1>

            <p class="text-[#3C5070] text-sm mt-1">
              Please fill in your details to register.
            </p>
          </div>

          <.form
            for={@form}
            phx-submit="register"
            phx-change="validate"
            class="space-y-4"
          >

            <!-- Full Name -->
            <div>
              <label
                for="customer_name"
                class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1"
              >
                Full Name
              </label>

              <input
                type="text"
                id="customer_name"
                name="customer[name]"
                value={@form[:name].value || ""}
                placeholder="John Doe"
                required
                class="w-full px-4 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
              />

              <%= if @changeset.action && @changeset.errors[:name] do %>
                <p class="mt-1 text-xs text-red-600">
                  {elem(@changeset.errors[:name], 0)}
                </p>
              <% end %>
            </div>

            <!-- Email & Phone -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">

              <!-- Email -->
              <div>
                <label
                  for="customer_email"
                  class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1"
                >
                  Email
                </label>

                <input
                  type="email"
                  id="customer_email"
                  name="customer[email]"
                  value={@form[:email].value || ""}
                  placeholder="john@example.com"
                  required
                  class="w-full px-4 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                />

                <%= if @changeset.action && @changeset.errors[:email] do %>
                  <p class="mt-1 text-xs text-red-600">
                    {elem(@changeset.errors[:email], 0)}
                  </p>
                <% end %>
              </div>

              <!-- Phone -->
              <div>
                <label
                  for="customer_phone"
                  class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1"
                >
                  Phone
                </label>

                <input
                  type="tel"
                  id="customer_phone"
                  name="customer[phone]"
                  value={@form[:phone].value || ""}
                  placeholder="+1 (555) 000-0000"
                  required
                  class="w-full px-4 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                />

                <%= if @changeset.action && @changeset.errors[:phone] do %>
                  <p class="mt-1 text-xs text-red-600">
                    {elem(@changeset.errors[:phone], 0)}
                  </p>
                <% end %>
              </div>

            </div>

            <!-- Passwords -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">

              <!-- Password -->
              <div>
                <label
                  for="customer_password"
                  class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1"
                >
                  Password
                </label>

                <div class="relative">
                  <input
                    type="password"
                    id="customer_password"
                    name="customer[password]"
                    value={@form[:password].value || ""}
                    placeholder="••••••••"
                    required
                    class="w-full pl-4 pr-12 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                  />

                  <button
                    type="button"
                    onclick="
                      const input = document.getElementById('customer_password');
                      const showIcon = document.getElementById('registration-eye-show');
                      const hideIcon = document.getElementById('registration-eye-hide');

                      if (input.type === 'password') {
                        input.type = 'text';
                        showIcon.classList.add('hidden');
                        hideIcon.classList.remove('hidden');
                      } else {
                        input.type = 'password';
                        showIcon.classList.remove('hidden');
                        hideIcon.classList.add('hidden');
                      }
                    "
                    class="absolute inset-y-0 right-0 pr-3.5 flex items-center text-[#3C5070] hover:text-[#112250] focus:outline-none transition"
                    aria-label="Toggle password visibility"
                  >
                    <svg
                      id="registration-eye-show"
                      class="w-5 h-5"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                      />
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                      />
                    </svg>

                    <svg
                      id="registration-eye-hide"
                      class="w-5 h-5 hidden"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858-5.908A8.982 8.982 0 0112 5c4.478 0 8.268 2.943 9.542 7 1.274 4.057 5.064 7 9.542 7 4.477 0 8.268-2.943 9.542-7z"
                      />
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M3 3l18 18"
                      />
                    </svg>
                  </button>
                </div>

                <%= if @changeset.action && @changeset.errors[:password] do %>
                  <p class="mt-1 text-xs text-red-600">
                    {elem(@changeset.errors[:password], 0)}
                  </p>
                <% end %>
              </div>

              <!-- Confirm Password -->
              <div>
                <label
                  for="customer_password_confirmation"
                  class="block text-xs font-bold text-[#3C5070] uppercase tracking-wider mb-1"
                >
                  Confirm Password
                </label>

                <div class="relative">
                  <input
                    type="password"
                    id="customer_password_confirmation"
                    name="customer[password_confirmation]"
                    value={@form[:password_confirmation].value || ""}
                    placeholder="••••••••"
                    required
                    class="w-full pl-4 pr-12 py-3 rounded-xl bg-[#F5F0E9]/60 border border-[#D9CBC2] text-[#112250] text-sm placeholder-[#3C5070]/40 transition duration-200 focus:outline-none focus:bg-white focus:border-[#112250] focus:ring-2 focus:ring-[#E0C58F]"
                  />

                  <button
                    type="button"
                    onclick="
                      const input = document.getElementById('customer_password_confirmation');
                      const showIcon = document.getElementById('registration-confirm-eye-show');
                      const hideIcon = document.getElementById('registration-confirm-eye-hide');

                      if (input.type === 'password') {
                        input.type = 'text';
                        showIcon.classList.add('hidden');
                        hideIcon.classList.remove('hidden');
                      } else {
                        input.type = 'password';
                        showIcon.classList.remove('hidden');
                        hideIcon.classList.add('hidden');
                      }
                    "
                    class="absolute inset-y-0 right-0 pr-3.5 flex items-center text-[#3C5070] hover:text-[#112250] focus:outline-none transition"
                    aria-label="Toggle confirm password visibility"
                  >
                    <svg
                      id="registration-confirm-eye-show"
                      class="w-5 h-5"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                      />
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                      />
                    </svg>

                    <svg
                      id="registration-confirm-eye-hide"
                      class="w-5 h-5 hidden"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858-5.908A8.982 8.982 0 0112 5c4.478 0 8.268 2.943 9.542 7 1.274 4.057 5.064-7 9.542-7 4.477 0 8.268 2.943 9.542 7z"
                      />
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M3 3l18 18"
                      />
                    </svg>
                  </button>
                </div>

                <%= if @changeset.action && @changeset.errors[:password_confirmation] do %>
                  <p class="mt-1 text-xs text-red-600">
                    {elem(@changeset.errors[:password_confirmation], 0)}
                  </p>
                <% end %>
              </div>

            </div>

            <!-- Submit -->
            <div class="pt-2">
              <button
                type="submit"
                class="w-full py-3.5 px-6 rounded-xl bg-[#E0C58F] hover:bg-[#D9CBC2] text-[#112250] font-bold text-sm tracking-wide transition-all duration-200 shadow-md hover:shadow-lg active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-[#112250] focus:ring-offset-2"
              >
                Register
              </button>
            </div>

          </.form>
        </div>
      </div>

    </div>
  </div>
  """
end
end

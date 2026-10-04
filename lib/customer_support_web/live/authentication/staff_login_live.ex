defmodule CustomerSupportWeb.StaffLoginLive do
  use CustomerSupportWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_password: false, password: "")}
  end

  def handle_event("validate", %{"staff" => %{"password" => password}}, socket) do
    {:noreply, assign(socket, :password, password)}
  end

  def handle_event("toggle_password_visibility", _params, socket) do
    {:noreply, update(socket, :show_password, &(!&1))}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-dvh w-full bg-[#112250] text-[#F5F0E9] grid grid-rows-[auto_1fr_auto] justify-items-center p-6 font-sans relative overflow-hidden selection:bg-[#E0C58F] selection:text-[#112250]">

      <!-- BACKGROUND MESH LIGHTS -->
      <div class="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[40rem] h-[40rem] rounded-full bg-[#3C5070]/40 blur-3xl pointer-events-none"></div>
      <div class="absolute bottom-10 right-10 w-[20rem] h-[20rem] rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

      <!-- HEADER -->
      <header class="w-full max-w-md pt-6 text-center space-y-2 z-10">
        <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-[#E0C58F]/30 bg-[#3C5070]/20 backdrop-blur-md">
          <div class="h-1.5 w-1.5 rounded-full bg-[#E0C58F]"></div>
          <span class="text-[10px] font-mono font-bold tracking-[0.3em] uppercase text-[#E0C58F]">
            SUPPORTDESK HQ
          </span>
        </div>
      </header>

      <!-- LOGIN CARD -->
      <main class="w-full max-w-md my-auto py-6 z-10 self-center">
        <div class="bg-[#3C5070]/20 backdrop-blur-xl rounded-3xl border border-[#E0C58F]/20 p-8 sm:p-10 shadow-2xl shadow-black/40 relative overflow-hidden">

          <!-- Top Accent Gold Bar -->
          <div class="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-transparent via-[#E0C58F] to-transparent"></div>

          <div class="mb-8 space-y-1">
            <span class="text-[10px] font-mono font-semibold text-[#E0C58F] uppercase tracking-widest block">
              Staff Access Only
            </span>
            <h1 class="text-2xl font-black text-[#F5F0E9] tracking-tight">
              Sign In
            </h1>
            <p class="text-xs text-[#D9CBC2] font-light">
              Enter your credentials to manage active support queues.
            </p>
          </div>

          <.form
            for={%{}}
            action="/support/staff/login"
            method="post"
            phx-change="validate"
            class="space-y-5"
          >
            <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

            <!-- EMAIL -->
            <div class="space-y-1.5">
              <label for="staff-email" class="block text-[10px] font-mono font-bold uppercase tracking-wider text-[#D9CBC2]">
                Email Address
              </label>
              <input
                id="staff-email"
                type="email"
                name="staff[email]"
                required
                placeholder="staff@supportdesk.com"
                class="w-full rounded-xl border border-[#3C5070] bg-[#112250]/70 px-4 py-3 text-xs text-[#F5F0E9] placeholder-[#3C5070] transition-all outline-none focus:border-[#E0C58F] focus:ring-1 focus:ring-[#E0C58F]"
              />
            </div>


            <!-- PASSWORD -->
              <div class="space-y-1.5">
                <div class="flex items-center justify-between">
                  <label
                    for="staff-password"
                    class="block text-[10px] font-mono font-bold uppercase tracking-wider text-[#D9CBC2]"
                  >
                    Password
                  </label>

                  <button
                    type="button"
                    phx-click="toggle_password_visibility"
                    class="text-[10px] font-semibold text-[#E0C58F] hover:underline cursor-pointer"
                  >
                    <%= if @show_password do %>
                      Hide
                    <% else %>
                      Show
                    <% end %>
                  </button>
                </div>

                <input
                  id="staff-password"
                  type={if @show_password, do: "text", else: "password"}
                  name="staff[password]"
                  value={@password}
                  required
                  placeholder="••••••••••••"
                  class="w-full rounded-xl border border-[#3C5070] bg-[#112250]/70 px-4 py-3 text-xs text-[#F5F0E9] placeholder-[#3C5070] transition-all outline-none focus:border-[#E0C58F] focus:ring-1 focus:ring-[#E0C58F]"
                />
              </div>
            <!-- SUBMIT -->
            <div class="pt-3">
              <button
                type="submit"
                class="w-full rounded-xl bg-[#E0C58F] hover:bg-[#F5F0E9] active:scale-[0.98] text-[#112250] py-3.5 px-4 text-xs font-mono font-bold uppercase tracking-widest transition-all shadow-lg shadow-black/20 flex items-center justify-center gap-2 group cursor-pointer"
              >
                <span>Authenticate</span>
                <span class="transition-transform group-hover:translate-x-1">→</span>
              </button>
            </div>
          </.form>
        </div>
      </main>

      <!-- FOOTER -->
      <footer class="pb-4 text-center text-[10px] font-mono text-[#3C5070] tracking-widest uppercase font-semibold z-10">
        Customer Support Management System
      </footer>

    </div>
    """
  end
end

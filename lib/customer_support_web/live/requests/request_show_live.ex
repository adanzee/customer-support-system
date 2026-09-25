defmodule CustomerSupportWeb.RequestShowLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests


  def mount(%{"id" => request_id}, session, socket) do
  customer_id = session["customer_id"]

  case Requests.get_request_for_customer(request_id, customer_id) do
    nil ->
      {:ok,
       socket
       |> put_flash(:error, "Request not found.")
       |> push_navigate(to: ~p"/requests")}

    request ->
      {:ok, assign(socket, :request, request)}
  end
end

  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto space-y-8 py-4 font-sans">

      <%= if @request do %>

        <!-- PAGE HEADER BANNER -->
        <div class="relative overflow-hidden rounded-3xl bg-[#112250] p-8 md:p-10 text-[#F5F0E9] shadow-xl">
          <div class="absolute -top-16 -left-16 w-48 h-48 rounded-full bg-[#3C5070]/30 blur-2xl pointer-events-none"></div>
          <div class="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-[#E0C58F]/10 blur-3xl pointer-events-none"></div>

          <div class="relative z-10 flex flex-col sm:flex-row sm:items-center justify-between gap-6">
            <div>
              <.link
                navigate={~p"/requests"}
                class="inline-flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-[#E0C58F] hover:text-[#F5F0E9] transition-colors mb-4"
              >
                <.icon name="hero-arrow-left" class="size-4" />
                Back to Requests
              </.link>

              <h1 class="text-3xl md:text-4xl font-extrabold tracking-tight text-[#F5F0E9]">
                Request Details
              </h1>
              <p class="mt-2 text-[#D9CBC2] text-sm md:text-base">
                View the information, details, and active progress of ticket.
              </p>
            </div>

            <!-- ID TAG IN HEADER -->
            <div class="bg-[#3C5070]/30 p-3 rounded-2xl border border-[#E0C58F]/20 backdrop-blur-sm self-start sm:self-auto">
              <span class="text-xs uppercase tracking-wider text-[#D9CBC2] block font-bold mb-0.5">Ticket UUID</span>
              <code class="font-mono text-xs text-[#E0C58F] break-all">
                <%= @request.request_id %>
              </code>
            </div>
          </div>
        </div>

        <!-- TWO-COLUMN CONTENT GRID -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

          <!-- MAIN TICKET CONTENT (2 COLUMNS) -->
          <div class="lg:col-span-2 space-y-6">
            <div class="rounded-3xl border border-[#D9CBC2]/60 bg-white p-8 shadow-sm">
              <div class="flex items-center gap-2 mb-2 text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                <.icon name="hero-document-text" class="size-4 text-[#112250]" />
                Subject / Title
              </div>

              <h2 class="text-2xl font-bold text-[#112250]">
                <%= @request.title %>
              </h2>

              <hr class="my-6 border-[#D9CBC2]/40" />

              <div class="flex items-center gap-2 mb-3 text-xs font-bold uppercase tracking-wider text-[#3C5070]">
                <.icon name="hero-bars-3-bottom-left" class="size-4 text-[#112250]" />
                Description
              </div>

              <div class="rounded-2xl border border-[#D9CBC2]/50 bg-[#F5F0E9]/50 p-6 leading-relaxed text-[#112250] min-h-[160px]">
                <p class="whitespace-pre-wrap font-normal text-base">
                  <%= @request.description %>
                </p>
              </div>
            </div>
          </div>

          <!-- SIDEBAR METADATA CARD (1 COLUMN) -->
          <div class="space-y-6">
            <div class="rounded-3xl border border-[#D9CBC2]/60 bg-white p-6 shadow-sm space-y-6">
              <h3 class="text-lg font-bold text-[#112250] border-b border-[#D9CBC2]/40 pb-4">
                Ticket Metadata
              </h3>

              <!-- Status -->
              <div>
                <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-2">Status</span>
                <%
                  status_str = String.downcase(to_string(@request.status))
                  {bg_cls, text_cls, dot_cls} = case status_str do
                    "open" -> {"bg-emerald-50 border-emerald-200", "text-emerald-800", "bg-emerald-500"}
                    "in_progress" -> {"bg-blue-50 border-blue-200", "text-blue-800", "bg-blue-500"}
                    "resolved" -> {"bg-gray-100 border-gray-200", "text-gray-700", "bg-gray-400"}
                    _ -> {"bg-[#F5F0E9] border-[#D9CBC2]", "text-[#112250]", "bg-[#3C5070]"}
                  end
                %>
                <span class={"inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold border #{bg_cls} #{text_cls}"}>
                  <span class={"w-2 h-2 rounded-full #{dot_cls}"}></span>
                  <%= Phoenix.Naming.humanize(@request.status) %>
                </span>
              </div>

              <!-- Priority -->
              <div>
                <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-2">Priority</span>
                <%
                  priority_str = String.downcase(to_string(@request.priority))
                  priority_bg = case priority_str do
                    "high" -> "bg-amber-100 text-amber-900 border-amber-300"
                    "urgent" -> "bg-rose-100 text-rose-900 border-rose-300"
                    "medium" -> "bg-[#E0C58F]/40 text-[#112250] border-[#E0C58F]"
                    _ -> "bg-[#F5F0E9] text-[#3C5070] border-[#D9CBC2]"
                  end
                %>
                <span class={"inline-flex px-3.5 py-1.5 rounded-full text-xs font-semibold border #{priority_bg}"}>
                  <%= Phoenix.Naming.humanize(@request.priority) %>
                </span>
              </div>

              <!-- Category -->
              <div>
                <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-1">Category</span>
                <p class="text-sm font-semibold text-[#112250] flex items-center gap-2">
                  <.icon name="hero-tag" class="size-4 text-[#3C5070]" />
                  <%= @request.category %>
                </p>
              </div>

              <hr class="border-[#D9CBC2]/40" />

              <!-- Timestamps -->
              <div class="space-y-4 pt-1">
                <div>
                  <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-1">Submitted On</span>
                  <p class="text-sm text-[#112250] font-medium flex items-center gap-2">
                    <.icon name="hero-calendar" class="size-4 text-[#3C5070]" />
                    <%= Calendar.strftime(@request.inserted_at, "%b %d, %Y at %I:%M %p") %>
                  </p>
                </div>

                <div>
                  <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-1">Last Updated</span>
                  <p class="text-sm text-[#112250] font-medium flex items-center gap-2">
                    <.icon name="hero-clock" class="size-4 text-[#3C5070]" />
                    <%= Calendar.strftime(@request.updated_at, "%b %d, %Y at %I:%M %p") %>
                  </p>
                </div>
              </div>

            </div>
          </div>

        </div>

      <% else %>

        <!-- NOT FOUND STATE -->
        <div class="rounded-3xl border border-[#D9CBC2]/60 bg-white p-12 text-center shadow-sm max-w-xl mx-auto my-12">
          <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-3xl bg-[#F5F0E9] text-[#112250] border border-[#D9CBC2]/40">
            <.icon name="hero-document-magnifying-glass" class="size-10 text-[#3C5070]" />
          </div>

          <h1 class="mt-6 text-2xl font-bold text-[#112250]">
            Request Not Found
          </h1>

          <p class="mt-2 text-[#3C5070] text-sm leading-relaxed">
            The support request you are looking for could not be found or may have been deleted.
          </p>

          <.link
            navigate={~p"/requests"}
            class="mt-8 inline-flex items-center gap-2 rounded-xl bg-[#112250] px-6 py-3 font-bold text-sm text-[#F5F0E9] shadow-md hover:bg-[#3C5070] transition-all duration-200"
          >
            <.icon name="hero-arrow-left" class="size-4" />
            Back to My Requests
          </.link>
        </div>

      <% end %>

    </div>
    """
  end
end

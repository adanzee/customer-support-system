defmodule CustomerSupportWeb.RequestShowLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests
  alias CustomerSupportWeb.DateTimeHelper

  def mount(%{"id" => request_id}, session, socket) do
    customer_id = session["customer_id"]

    case Requests.get_request_for_customer(request_id, customer_id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Request not found.")
         |> push_navigate(to: ~p"/requests")}

      request ->
        messages =
          Requests.list_messages_for_customer_request(
            request_id,
            customer_id
          )

        {:ok,
         socket
         |> assign(:request, request)
         |> assign(:messages, messages)
         |> assign(:message_body, "")
         |> assign(:message_error, nil)}
    end
  end

  def handle_event("update_message", %{"message" => %{"body" => body}}, socket) do
    {:noreply,
     socket
     |> assign(:message_body, body)
     |> assign(:message_error, nil)}
  end

  def handle_event("send_message", %{"message" => %{"body" => body}}, socket) do
    customer_id = socket.assigns.request.customer_id
    request_id = socket.assigns.request.request_id

    case Requests.create_customer_message(request_id, customer_id, body) do
      {:ok, message} ->
        {:noreply,
         socket
         |> update(:messages, fn messages -> messages ++ [message] end)
         |> assign(:message_body, "")
         |> assign(:message_error, nil)}

      {:error, :unauthorized} ->
        {:noreply,
         socket
         |> put_flash(:error, "You are not authorized to message this request.")}

      {:error, changeset} ->
        message_error =
          case Keyword.get(changeset.errors, :body) do
            {"can't be blank", _} -> "Message cannot be empty."
            _ -> "Message could not be sent."
          end

        {:noreply, assign(socket, :message_error, message_error)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto space-y-8 py-4 font-sans">

      <%= if @request do %>

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

            <div class="bg-[#3C5070]/30 p-3 rounded-2xl border border-[#E0C58F]/20 backdrop-blur-sm self-start sm:self-auto">
              <span class="text-xs uppercase tracking-wider text-[#D9CBC2] block font-bold mb-0.5">
                Ticket UUID
              </span>

              <code class="font-mono text-xs text-[#E0C58F] break-all">
                <%= @request.request_id %>
              </code>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

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
                <p class="whitespace-pre-wrap font-normal text-base text-left"><%= String.trim(@request.description || "") %></p>
              </div>

            </div>
          </div>

          <div class="space-y-6">
            <div class="rounded-3xl border border-[#D9CBC2]/60 bg-white p-6 shadow-sm space-y-6">

              <h3 class="text-lg font-bold text-[#112250] border-b border-[#D9CBC2]/40 pb-4">
                Ticket Metadata
              </h3>

              <!-- Status -->
              <div>
                <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-2">
                  Status
                </span>

                <%
                  status_str = String.downcase(to_string(@request.status))

                  {bg_cls, text_cls, dot_cls} =
                    case status_str do
                      "open" ->
                        {"bg-emerald-50 border-emerald-200", "text-emerald-800", "bg-emerald-500"}

                      "in_progress" ->
                        {"bg-blue-50 border-blue-200", "text-blue-800", "bg-blue-500"}

                      "resolved" ->
                        {"bg-gray-100 border-gray-200", "text-gray-700", "bg-gray-400"}

                      _ ->
                        {"bg-[#F5F0E9] border-[#D9CBC2]", "text-[#112250]", "bg-[#3C5070]"}
                    end
                %>

                <span class={"inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold border #{bg_cls} #{text_cls}"}>
                  <span class={"w-2 h-2 rounded-full #{dot_cls}"}></span>
                  <%= Phoenix.Naming.humanize(@request.status) %>
                </span>
              </div>

              <!-- Priority -->
              <div>
                <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-2">
                  Priority
                </span>

                <%
                  priority_str = String.downcase(to_string(@request.priority))

                  priority_bg =
                    case priority_str do
                      "high" ->
                        "bg-amber-100 text-amber-900 border-amber-300"

                      "urgent" ->
                        "bg-rose-100 text-rose-900 border-rose-300"

                      "medium" ->
                        "bg-[#E0C58F]/40 text-[#112250] border-[#E0C58F]"

                      _ ->
                        "bg-[#F5F0E9] text-[#3C5070] border-[#D9CBC2]"
                    end
                %>

                <span class={"inline-flex px-3.5 py-1.5 rounded-full text-xs font-semibold border #{priority_bg}"}>
                  <%= Phoenix.Naming.humanize(@request.priority) %>
                </span>
              </div>

              <!-- Category -->
              <div>
                <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-1">
                  Category
                </span>

                <p class="text-sm font-semibold text-[#112250] flex items-center gap-2">
                  <.icon name="hero-tag" class="size-4 text-[#3C5070]" />
                  <%= @request.category %>
                </p>
              </div>

              <hr class="border-[#D9CBC2]/40" />

              <!-- Timestamps -->
              <div class="space-y-4 pt-1">

                <div>
                  <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-1">
                    Submitted On
                  </span>

                  <p class="text-sm text-[#112250] font-medium flex items-center gap-2">
                    <.icon name="hero-calendar" class="size-4 text-[#3C5070]" />
                    <%= DateTimeHelper.format_local(@request.inserted_at) %>
                  </p>
                </div>

                <div>
                  <span class="text-xs font-bold uppercase tracking-wider text-[#3C5070] block mb-1">
                    Last Updated
                  </span>

                  <p class="text-sm text-[#112250] font-medium flex items-center gap-2">
                    <.icon name="hero-clock" class="size-4 text-[#3C5070]" />
                    <%= DateTimeHelper.format_local(@request.updated_at) %>
                  </p>
                </div>

              </div>

            </div>
          </div>

        </div>

        <!-- Conversation -->
        <div class="rounded-3xl border border-[#D9CBC2]/60 bg-white p-8 shadow-sm">

          <div class="flex items-center gap-3 mb-6">
            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-[#F5F0E9]">
              <.icon name="hero-chat-bubble-left-right" class="size-5 text-[#112250]" />
            </div>

            <div>
              <h2 class="text-xl font-bold text-[#112250]">
                Conversation
              </h2>

              <p class="text-sm text-[#3C5070]">
                Communicate with the support team about your request.
              </p>
            </div>
          </div>

          <!-- Messages -->
            <div class="space-y-4 mb-6">
              <%= if @messages == [] do %>
                <div class="rounded-2xl border border-dashed border-[#D9CBC2] bg-[#F5F0E9]/40 p-8 text-center">
                  <.icon name="hero-chat-bubble-left" class="size-8 mx-auto text-[#3C5070]" />
                  <p class="mt-3 text-sm font-medium text-[#3C5070]">
                    No messages yet.
                  </p>
                  <p class="text-xs text-[#3C5070]/70 mt-1">
                    Send a message to start the conversation.
                  </p>
                </div>
              <% else %>
                <%= for message <- @messages do %>
                  <% is_customer = message.sender_type == "customer" %>

                  <!-- Wrapper controlling left/right alignment and max width -->
                  <div class={"flex flex-col #{if is_customer, do: "items-end", else: "items-start"}"}>

                    <!-- Header: Sender & Timestamp -->
                    <div class="flex items-center gap-2 mb-1 px-1">
                      <span class="text-xs font-bold text-[#112250]">
                        <%= if is_customer, do: "You", else: "Support Team" %>
                      </span>
                      <span class="text-[11px] text-[#3C5070]/70">
                        <%= DateTimeHelper.format_local(message.inserted_at || @request.inserted_at) %>
                      </span>
                    </div>

                    <!-- Chat Bubble (Fits content with max width) -->
                    <div class={"inline-block max-w-[85%] rounded-2xl border px-4 py-2.5 shadow-sm #{if is_customer, do: "bg-[#112250] text-[#F5F0E9] border-[#112250] rounded-tr-none", else: "bg-[#F5F0E9]/80 text-[#112250] border-[#D9CBC2]/60 rounded-tl-none"}"}>
                      <p class="text-sm whitespace-pre-wrap leading-normal"><%= String.trim(message.body || "") %></p>
                    </div>

                  </div>
                <% end %>
              <% end %>
            </div>
          <!-- Send Message -->

            <.form
              for={%{}}
              phx-submit="send_message"
              class="border-t border-[#D9CBC2]/40 pt-6"
            >
              <label class="block text-xs font-bold uppercase tracking-wider text-[#3C5070] mb-2">
                Send a Message
              </label>

              <div class="relative flex items-end rounded-2xl border border-[#D9CBC2] bg-white p-2 focus-within:border-[#3C5070] focus-within:ring-1 focus-within:ring-[#3C5070] transition-all">
                <textarea
                  name="message[body]"
                  rows="2"
                  placeholder="Type your message..."
                  value={@message_body}
                  phx-change="update_message"
                  class="w-full resize-none border-0 bg-transparent px-3 py-1.5 text-sm text-[#112250] placeholder-[#3C5070]/50 focus:ring-0 focus:outline-none"
                ></textarea>

                <button
                  type="submit"
                  class="ml-2 inline-flex shrink-0 items-center gap-2 rounded-xl bg-[#112250] px-5 py-2.5 text-xs font-bold text-[#F5F0E9] shadow-sm hover:bg-[#3C5070] transition-all duration-200"
                >
                  <.icon name="hero-paper-airplane" class="size-4" />
                  <span>Send</span>
                </button>
              </div>
            </.form>
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

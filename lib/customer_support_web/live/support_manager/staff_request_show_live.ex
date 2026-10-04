defmodule CustomerSupportWeb.StaffRequestShowLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff
  alias CustomerSupportWeb.DateTimeHelper

  on_mount {CustomerSupportWeb.StaffAuthHook, :default}

  def mount(%{"id" => request_id}, _session, socket) do
    staff_id = socket.assigns.current_staff.staff_id

    case SupportStaff.get_assigned_request(staff_id, request_id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Request not found.")
         |> push_navigate(to: "/support/staff/dashboard")}

      request ->
        topic = "request:#{request_id}"

        Phoenix.PubSub.subscribe(
          CustomerSupport.PubSub,
          topic
        )

         {:ok,
         socket
         |> assign(:request, request)
         |> assign(:message_body, "")
         |> assign(:reply_form_key, 0)}
    end
  end

  def handle_info({:new_message, _message}, socket) do
    staff_id = socket.assigns.current_staff.staff_id
    request_id = socket.assigns.request.request_id

    request =
      SupportStaff.get_assigned_request(staff_id, request_id)

    {:noreply, assign(socket, :request, request)}
  end

  def handle_info({:status_updated, _request_id, status}, socket) do
    {:noreply,
    socket
    |> assign(:request, %{socket.assigns.request | status: status})
    |> put_flash(:info, "Request status updated to #{status}.")}
  end

  def handle_event("update_status", %{"status" => status}, socket) do
    staff_id = socket.assigns.current_staff.staff_id
    request_id = socket.assigns.request.request_id

    case SupportStaff.update_request_status(staff_id, request_id, status) do
      {:ok, _request} ->
        request =
          SupportStaff.get_assigned_request(staff_id, request_id)

        {:noreply,
         socket
         |> assign(:request, request)
         |> put_flash(:info, "Request status updated successfully.")}

      {:error, :request_not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "Request not found.")}

      {:error, :invalid_status_transition} ->
        {:noreply,
         put_flash(socket, :error, "Invalid status transition.")}
    end
  end

  def handle_event("send_message", %{"body" => body}, socket) do
    staff_id = socket.assigns.current_staff.staff_id
    request_id = socket.assigns.request.request_id

    case SupportStaff.create_request_message(staff_id, request_id, body) do
      {:ok, _message} ->
        request =
          SupportStaff.get_assigned_request(staff_id, request_id)


      {:noreply,
      socket
      |> assign(:request, request)
      |> assign(:reply_form_key, socket.assigns.reply_form_key + 1)
      |> put_flash(:info, "Message sent successfully.")}

      {:error, :request_not_found} ->
        {:noreply,
        put_flash(socket, :error, "Request not found.")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-dvh w-full bg-[#F5F0E9] text-[#112250] font-sans selection:bg-[#E0C58F] selection:text-[#112250]">

      <!-- TOP BRAND NAVIGATION HEADER -->
      <header class="bg-[#112250] border-b border-[#3C5070]/40 text-[#F5F0E9] shadow-md">
        <div class="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">

          <div class="flex items-center gap-4">
            <.link
              navigate={~p"/support/staff/dashboard"}
              class="inline-flex items-center gap-1 text-xs font-mono font-bold uppercase tracking-wider text-[#E0C58F] hover:text-[#F5F0E9] transition-colors"
            >
              ← Back to Dashboard
            </.link>

            <span class="h-4 w-px bg-[#3C5070]"></span>

            <div>
              <h1 class="text-base font-bold tracking-tight text-[#F5F0E9]">
                Request Details
              </h1>

              <p class="text-[11px] font-mono text-[#D9CBC2]/80 uppercase tracking-wider truncate max-w-[200px] sm:max-w-xs">
                ID: <%= @request.request_id %>
              </p>
            </div>
          </div>

          <div class="text-right">
            <p class="text-xs font-bold text-[#F5F0E9]">
              <%= @current_staff.name %>
            </p>

            <p class="text-[11px] font-mono text-[#E0C58F]">
              <%= @current_staff.staff_identifier %>
            </p>
          </div>

        </div>
      </header>

      <!-- FLASH MESSAGES -->
      <div class="mx-auto max-w-7xl px-6 pt-6">

        <%= if Phoenix.Flash.get(@flash, :info) do %>
          <div class="rounded-xl border border-[#3C5070] bg-[#3C5070]/10 px-4 py-3 text-xs font-medium text-[#112250] shadow-sm">
            <%= Phoenix.Flash.get(@flash, :info) %>
          </div>
        <% end %>

        <%= if Phoenix.Flash.get(@flash, :error) do %>
          <div class="rounded-xl border border-red-300 bg-red-50 px-4 py-3 text-xs font-medium text-red-800 shadow-sm">
            <%= Phoenix.Flash.get(@flash, :error) %>
          </div>
        <% end %>

      </div>

      <!-- MAIN GRID CONTAINER -->
      <main class="mx-auto grid max-w-7xl grid-cols-1 gap-8 px-6 py-6 lg:grid-cols-[1fr_360px]">

        <!-- LEFT COLUMN -->
        <div class="space-y-6">

          <!-- REQUEST MAIN INFO CARD -->
          <section class="overflow-hidden rounded-2xl border border-[#D9CBC2] bg-white shadow-sm">

            <div class="border-b border-[#D9CBC2] bg-[#F5F0E9]/60 px-6 py-5">

              <div class="flex flex-col sm:flex-row sm:items-start justify-between gap-4">

                <div>
                  <h2 class="text-xl font-black text-[#112250] tracking-tight">
                    <%= @request.title %>
                  </h2>

                  <p class="mt-1 text-xs text-[#3C5070] font-medium">
                    Submitted by
                    <span class="font-bold text-[#112250]">
                      <%= @request.customer.name %>
                    </span>
                  </p>
                </div>

                <!-- Status Badge -->
                <span class={[
                  "shrink-0 self-start inline-flex rounded-full px-3 py-1 text-[10px] font-mono font-bold uppercase tracking-wider border",
                  case @request.status do
                    "Open" ->
                      "bg-[#112250] text-[#F5F0E9] border-[#112250]"

                    "In Progress" ->
                      "bg-[#3C5070] text-[#F5F0E9] border-[#3C5070]"

                    "Waiting for Customer" ->
                      "bg-[#E0C58F]/30 text-[#112250] border-[#E0C58F]"

                    "Resolved" ->
                      "bg-[#D9CBC2]/40 text-[#112250] border-[#D9CBC2]"

                    "Closed" ->
                      "bg-[#F5F0E9] text-[#3C5070] border-[#D9CBC2]"

                    "Reopened" ->
                      "bg-[#112250] text-[#E0C58F] border-[#112250]"

                    _ ->
                      "bg-[#F5F0E9] text-[#3C5070] border-[#D9CBC2]"
                  end
                ]}>
                  <%= @request.status %>
                </span>

              </div>
            </div>

            <div class="px-6 py-6 space-y-6">

              <div>
                <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                  Description
                </p>

                <div class="mt-2 rounded-xl bg-[#F5F0E9]/40 border border-[#D9CBC2]/60 p-4">
                  <p class="whitespace-pre-wrap text-xs leading-relaxed text-[#112250]"><%= @request.description %></p>
                </div>
              </div>

              <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 pt-2 border-t border-[#D9CBC2]/50">

                <div>
                  <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                    Category
                  </p>

                  <span class="mt-1.5 inline-block rounded-lg bg-[#F5F0E9] border border-[#D9CBC2] px-3 py-1 text-xs font-mono font-medium text-[#112250]">
                    <%= @request.category %>
                  </span>
                </div>

                <div>
                  <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                    Priority Level
                  </p>

                  <p class={[
                    "mt-1.5 text-xs font-mono font-bold uppercase tracking-wider",
                    case @request.priority do
                      "Critical" ->
                        "text-[#112250] underline decoration-[#E0C58F] decoration-2"

                      "High" ->
                        "text-[#112250]"

                      "Medium" ->
                        "text-[#3C5070]"

                      _ ->
                        "text-[#3C5070]/70"
                    end
                  ]}>
                    <%= @request.priority %>
                  </p>
                </div>

              </div>

            </div>

          </section>

          <!-- STATUS UPDATE CARD -->
          <section class="rounded-2xl border border-[#D9CBC2] bg-white p-6 shadow-sm">

            <h3 class="text-xs font-mono font-bold uppercase tracking-wider text-[#112250]">
              Update Request Status
            </h3>

            <p class="mt-1 text-xs text-[#3C5070]">
              Transition this request through the operational support workflow.
            </p>

            <.form
              for={%{}}
              phx-submit="update_status"
              class="mt-4 flex flex-col sm:flex-row gap-3"
            >

              <select
                name="status"
                class="flex-1 rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/30 px-3.5 py-2 text-xs font-medium text-[#112250] focus:border-[#112250] focus:outline-none focus:ring-1 focus:ring-[#112250]"
              >
                <option value="Open" selected={@request.status == "Open"}>
                  Open
                </option>

                <option value="In Progress" selected={@request.status == "In Progress"}>
                  In Progress
                </option>

                <option value="Waiting for Customer" selected={@request.status == "Waiting for Customer"}>
                  Waiting for Customer
                </option>

                <option value="Resolved" selected={@request.status == "Resolved"}>
                  Resolved
                </option>

                <option value="Closed" selected={@request.status == "Closed"}>
                  Closed
                </option>

                <option value="Reopened" selected={@request.status == "Reopened"}>
                  Reopened
                </option>
              </select>

              <button
                type="submit"
                class="rounded-xl border border-[#112250] bg-[#112250] px-6 py-2 text-xs font-mono font-bold uppercase tracking-wider text-[#F5F0E9] transition hover:bg-[#3C5070] hover:border-[#3C5070] active:scale-[0.98]"
              >
                Update Status
              </button>

            </.form>

          </section>

          <!-- CONVERSATION / MESSAGES CARD -->
          <section class="overflow-hidden rounded-2xl border border-[#D9CBC2] bg-white shadow-sm">

            <div class="border-b border-[#D9CBC2] bg-[#F5F0E9]/60 px-6 py-4">

              <h3 class="text-xs font-mono font-bold uppercase tracking-wider text-[#112250]">
                Conversation History
              </h3>

              <p class="mt-0.5 text-xs text-[#3C5070]">
                Direct communication transcript with the customer.
              </p>

            </div>

            <div class="max-h-[500px] space-y-4 overflow-y-auto px-6 py-6 bg-[#F5F0E9]/20">

              <%= if @request.messages == [] do %>

                <div class="py-12 text-center bg-white rounded-xl border border-[#D9CBC2]/60">

                  <div class="mx-auto flex h-10 w-10 items-center justify-center rounded-xl bg-[#F5F0E9] text-[#3C5070]">
                    💬
                  </div>

                  <p class="mt-3 text-xs font-bold text-[#112250]">
                    No messages exchanged yet
                  </p>

                  <p class="mt-1 text-xs text-[#3C5070]">
                    Send a message below to start the conversation.
                  </p>

                </div>

              <% else %>

                <%= for message <- @request.messages do %>
                  <div class={[
                    "flex flex-col gap-1",
                    if(
                      message.sender_type == "staff",
                      do: "items-end",
                      else: "items-start"
                    )
                  ]}>

                    <div class="flex items-center gap-2 text-xs">
                      <span class="font-bold text-[#112250]">
                        <%= if message.sender_type == "staff",
                          do: "You",
                          else: "Customer" %>
                      </span>

                     <span class="text-[11px] text-[#3C5070]/70">
                        <%= CustomerSupportWeb.DateTimeHelper.format_local(message.inserted_at) %>
                      </span>
                    </div>

                    <div class={[
                      "inline-block rounded-xl px-3 py-1.5 shadow-sm border text-xs max-w-[85%] sm:max-w-[70%]",
                      if(
                        message.sender_type == "staff",
                        do:
                          "bg-[#112250] text-[#F5F0E9] border-[#112250] rounded-tr-none text-right",
                        else:
                          "bg-[#F5F0E9] text-[#112250] border-[#D9CBC2] rounded-tl-none text-left"
                      )
                    ]}>
                      <span class="whitespace-pre-wrap break-words leading-snug"><%= String.trim(message.body || "") %></span>
                    </div>

                  </div>
                <% end %>

              <% end %>

            </div>

            <!-- REPLY FORM -->
            <div class="border-t border-[#D9CBC2] p-4 bg-white">

              <.form
                id={"reply-form-#{@reply_form_key}"}
                for={%{}}
                phx-submit="send_message"
              >

                <textarea
                  name="body"
                  placeholder="Write your response to the customer..."
                  required
                  rows="2"
                  class="w-full resize-none rounded-xl border border-[#D9CBC2] bg-[#F5F0E9]/30 p-3 text-xs text-[#112250] placeholder:text-[#3C5070]/60 focus:border-[#112250] focus:outline-none focus:ring-1 focus:ring-[#112250]"
                ></textarea>

                <div class="mt-2.5 flex justify-end">

                  <button
                    type="submit"
                    class="rounded-xl border border-[#E0C58F] bg-[#E0C58F] px-5 py-2 text-xs font-mono font-bold uppercase tracking-wider text-[#112250] transition hover:bg-[#112250] hover:text-[#F5F0E9] hover:border-[#112250] active:scale-[0.98]"
                  >
                    Send Response →
                  </button>

                </div>

              </.form>

            </div>

          </section>

        </div>

        <!-- RIGHT COLUMN -->
        <aside class="space-y-6">

          <!-- CUSTOMER PROFILE CARD -->
          <section class="rounded-2xl border border-[#D9CBC2] bg-white p-5 shadow-sm">

            <h3 class="text-xs font-mono font-bold uppercase tracking-wider text-[#112250] border-b border-[#D9CBC2]/60 pb-3">
              Customer Profile
            </h3>

            <div class="mt-4 space-y-4">

              <div>
                <p class="text-base font-bold text-[#112250]">
                  <%= @request.customer.name %>
                </p>
              </div>

              <div class="space-y-3 pt-1">

                <div>
                  <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                    Email Address
                  </p>

                  <p class="mt-0.5 break-all font-mono text-xs text-[#112250]">
                    <%= @request.customer.email %>
                  </p>
                </div>

                <div>
                  <p class="text-[10px] font-mono font-bold uppercase tracking-widest text-[#3C5070]">
                    Phone Contact
                  </p>

                  <p class="mt-0.5 font-mono text-xs text-[#112250]">
                    <%= @request.customer.phone %>
                  </p>
                </div>

              </div>

            </div>

          </section>

          <!-- REQUEST SUMMARY METADATA CARD -->
          <section class="rounded-2xl border border-[#D9CBC2] bg-white p-5 shadow-sm">

            <h3 class="text-xs font-mono font-bold uppercase tracking-wider text-[#112250] border-b border-[#D9CBC2]/60 pb-3">
              Request Summary
            </h3>

            <div class="mt-4 space-y-3 text-xs">

              <div class="flex items-center justify-between py-1 border-b border-[#D9CBC2]/40">
                <span class="font-mono text-[#3C5070]">
                  ID
                </span>

                <span class="max-w-[170px] truncate font-mono font-bold text-[#112250]">
                  <%= @request.request_id %>
                </span>
              </div>

              <div class="flex items-center justify-between py-1 border-b border-[#D9CBC2]/40">
                <span class="font-mono text-[#3C5070]">
                  Category
                </span>

                <span class="font-bold text-[#112250]">
                  <%= @request.category %>
                </span>
              </div>

              <div class="flex items-center justify-between py-1 border-b border-[#D9CBC2]/40">
                <span class="font-mono text-[#3C5070]">
                  Priority
                </span>

                <span class="font-mono font-bold text-[#112250]">
                  <%= @request.priority %>
                </span>
              </div>

              <div class="flex items-center justify-between py-1">
                <span class="font-mono text-[#3C5070]">
                  Status
                </span>

                <span class="font-mono font-bold text-[#112250]">
                  <%= @request.status %>
                </span>
              </div>

            </div>

          </section>

        </aside>

      </main>

    </div>
    """
  end
end

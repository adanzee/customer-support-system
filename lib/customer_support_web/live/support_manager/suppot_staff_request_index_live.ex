defmodule CustomerSupportWeb.SupportStaffRequestIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Requests

  on_mount {CustomerSupportWeb.StaffAuthHook, :default}

  def mount(_params, _session, socket) do
    staff_id = socket.assigns.current_staff.staff_id

    requests =
      Requests.search_and_filter_staff_requests(
        staff_id,
        %{
          status: [],
          priority: [],
          category: [],
          date_from: nil,
          date_to: nil
        }
      )

    {:ok,
     socket
     |> assign(:requests, requests)
     |> assign(:filters, %{
       status: [],
       priority: [],
       category: [],
       date_from: nil,
       date_to: nil
     })}
  end

  def handle_event("apply_filters", params, socket) do
  filters = %{
    status: Map.get(params, "status", []),
    priority: Map.get(params, "priority", []),
    category: Map.get(params, "category", []),
    date_from: Map.get(params, "date_from"),
    date_to: Map.get(params, "date_to")
  }

  requests =
    Requests.search_and_filter_staff_requests(
      socket.assigns.staff_id,
      filters
    )

  {:noreply,
   socket
   |> assign(:filters, filters)
   |> assign(:requests, requests)}
end

def render(assigns) do
  ~H"""
  <div>
    <h1>My Customer Requests</h1>

    <form id="request-filters" phx-submit="apply_filters">
    </form>

    <table>
      <thead>
        <tr>
          <th>Request</th>
          <th>Title</th>
          <th>Customer</th>

          <!-- Status -->
          <th>
            <details>
              <summary>Status</summary>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="status[]"
                    value="Open"
                    form="request-filters"
                  />
                  Open
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="status[]"
                    value="In Progress"
                    form="request-filters"
                  />
                  In Progress
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="status[]"
                    value="Waiting for Customer"
                    form="request-filters"
                  />
                  Waiting for Customer
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="status[]"
                    value="Resolved"
                    form="request-filters"
                  />
                  Resolved
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="status[]"
                    value="Closed"
                    form="request-filters"
                  />
                  Closed
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="status[]"
                    value="Reopened"
                    form="request-filters"
                  />
                  Reopened
                </label>
              </div>
            </details>
          </th>

          <!-- Priority -->
          <th>
            <details>
              <summary>Priority</summary>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="priority[]"
                    value="Low"
                    form="request-filters"
                  />
                  Low
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="priority[]"
                    value="Medium"
                    form="request-filters"
                  />
                  Medium
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="priority[]"
                    value="High"
                    form="request-filters"
                  />
                  High
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="priority[]"
                    value="Critical"
                    form="request-filters"
                  />
                  Critical
                </label>
              </div>
            </details>
          </th>

          <!-- Category -->
          <th>
            <details>
              <summary>Category</summary>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="category[]"
                    value="Technical"
                    form="request-filters"
                  />
                  Technical
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="category[]"
                    value="Billing"
                    form="request-filters"
                  />
                  Billing
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="category[]"
                    value="Account"
                    form="request-filters"
                  />
                  Account
                </label>
              </div>

              <div>
                <label>
                  <input
                    type="checkbox"
                    name="category[]"
                    value="General"
                    form="request-filters"
                  />
                  General
                </label>
              </div>
            </details>
          </th>

          <!-- Date -->
          <th>
            <details>
              <summary>Date</summary>

              <div>
                <label>
                  From
                  <input
                    type="date"
                    name="date_from"
                    form="request-filters"
                  />
                </label>
              </div>

              <div>
                <label>
                  To
                  <input
                    type="date"
                    name="date_to"
                    form="request-filters"
                  />
                </label>
              </div>
            </details>
          </th>
        </tr>
      </thead>

      <tbody>
        <%= if @requests == [] do %>
          <tr>
            <td colspan="7">No requests found.</td>
          </tr>
        <% else %>
          <%= for request <- @requests do %>
            <tr>
              <td>
              <.link navigate={~p"/support/manager/requests/#{request.request_id}"}>
                <%= request.request_id %>
              </.link>
            </td>
              <td><%= request.title %></td>
              <td><%= request.customer.name %></td>
              <td><%= request.status %></td>
              <td><%= request.priority %></td>
              <td><%= request.category %></td>
              <td>
                <%= Calendar.strftime(
                  request.inserted_at,
                  "%Y-%m-%d"
                ) %>
              </td>
            </tr>
          <% end %>
        <% end %>
      </tbody>
    </table>

    <button type="submit" form="request-filters">
      Search
    </button>
  </div>
  """
end
end

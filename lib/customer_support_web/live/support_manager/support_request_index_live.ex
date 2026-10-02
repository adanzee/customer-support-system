defmodule CustomerSupportWeb.SupportRequestIndexLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.Repo
  alias CustomerSupport.Requests
  alias CustomerSupport.Requests.Request
  alias CustomerSupport.SupportStaff

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  def mount(_params, _session, socket) do
    requests =
      Requests.search_and_filter_requests("", %{})

    staff = SupportStaff.list_staff()

    {:ok,
     socket
     |> assign(:requests, requests)
     |> assign(:staff, staff)
     |> assign(:filters, %{
       status: [],
       priority: [],
       category: [],
       staff_id: [],
       date_from: nil,
       date_to: nil
     })}
  end

  def handle_event("apply_filters", params, socket) do
    filters = %{
      status: Map.get(params, "status", []),
      priority: Map.get(params, "priority", []),
      category: Map.get(params, "category", []),
      staff_id: Map.get(params, "staff_id", []),
      date_from: Map.get(params, "date_from"),
      date_to: Map.get(params, "date_to")
    }

    requests =
      Requests.search_and_filter_requests("", filters)

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> assign(:requests, requests)}
  end

  def handle_event(
        "assign_staff",
        %{"request_id" => request_id, "staff_id" => staff_id},
        socket
      ) do
    request = Repo.get!(Request, request_id)

    changeset =
      Request.changeset(request, %{staff_id: staff_id})

    case Repo.update(changeset) do
      {:ok, _updated_request} ->
        requests =
          Requests.search_and_filter_requests(
            "",
            socket.assigns.filters
          )

        {:noreply,
         socket
         |> assign(:requests, requests)
         |> put_flash(:info, "Staff assigned successfully.")}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Customer Requests</h1>

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

            <!-- Staff -->
            <th>
              <details>
                <summary>Staff</summary>

                <div>
                  <label>
                    <input
                      type="checkbox"
                      name="staff_id[]"
                      value=""
                      form="request-filters"
                    />
                    Unassigned
                  </label>
                </div>

                <%= for staff <- @staff do %>
                  <div>
                    <label>
                      <input
                        type="checkbox"
                        name="staff_id[]"
                        value={staff.staff_id}
                        form="request-filters"
                      />

                      <%= staff.staff_identifier %> - <%= staff.name %>
                    </label>
                  </div>
                <% end %>
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
              <td colspan="8">No requests found.</td>
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
                  <%= if request.staff do %>
                    <p>
                      <%= request.staff.staff_identifier %> -
                      <%= request.staff.name %>
                    </p>

                    <.form for={%{}} phx-submit="assign_staff">
                      <input
                        type="hidden"
                        name="request_id"
                        value={request.request_id}
                      />

                      <select name="staff_id">
                        <option value="">Unassigned</option>

                        <%= for staff <- @staff do %>
                          <option value={staff.staff_id}>
                            <%= staff.staff_identifier %> -
                            <%= staff.name %>
                          </option>
                        <% end %>
                      </select>

                      <button type="submit">Reassign</button>
                    </.form>
                  <% else %>
                    <p>Unassigned</p>

                    <.form for={%{}} phx-submit="assign_staff">
                      <input
                        type="hidden"
                        name="request_id"
                        value={request.request_id}
                      />

                      <select name="staff_id">
                        <option value="">Select Staff</option>

                        <%= for staff <- @staff do %>
                          <option value={staff.staff_id}>
                            <%= staff.staff_identifier %> -
                            <%= staff.name %>
                          </option>
                        <% end %>
                      </select>

                      <button type="submit">Assign</button>
                    </.form>
                  <% end %>
                </td>

                <td>
                  <%= Calendar.strftime(request.inserted_at, "%Y-%m-%d") %>
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

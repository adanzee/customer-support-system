defmodule CustomerSupport.Requests do
  import Ecto.Query

  alias CustomerSupport.Repo
  alias CustomerSupport.Requests.Message
  alias CustomerSupport.Requests.Request
  alias CustomerSupport.PubSub

  def create_request(attrs) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  def list_requests do
    Request
    |> order_by([r], desc: r.inserted_at)
    |> Repo.all()
  end

  def search_and_filter_requests(search, filters) do
    Request
    |> join(:left, [r], c in assoc(r, :customer))
    |> join(:left, [r, c], s in assoc(r, :staff))
    |> apply_search(search)
    |> apply_filters(filters)
    |> order_by([r], desc: r.inserted_at)
    |> preload([_r, c, s], customer: c, staff: s)
    |> Repo.all()
  end

  def search_and_filter_staff_requests(staff_id, filters) do
    Request
    |> where([r], r.staff_id == ^staff_id)
    |> apply_filters(filters)
    |> order_by([r], desc: r.inserted_at)
    |> preload([:customer, :staff])
    |> Repo.all()
  end

  defp apply_search(query, search) when search in [nil, ""], do: query

  defp apply_search(query, search) do
    search = "%#{search}%"

   where(
      query,
      [r, c, s],
      fragment("?::text ILIKE ?", r.request_id, ^search) or
        ilike(r.title, ^search) or
        ilike(r.description, ^search) or
        ilike(r.category, ^search) or
        ilike(r.status, ^search) or
        ilike(r.priority, ^search) or
        ilike(c.name, ^search) or
        ilike(c.email, ^search) or
        ilike(s.name, ^search)
    )
  end

 defp apply_filters(query, filters) do
    query
    |> filter_status(filters[:status])
    |> filter_priority(filters[:priority])
    |> filter_category(filters[:category])
    |> filter_customer(filters[:customer_id])
    |> filter_staff(filters[:staff_id])
    |> filter_date_range(filters[:date_from], filters[:date_to])
  end


  defp filter_category(query, category) when category in [nil, ""], do: query
  defp filter_category(query, []), do: query

  defp filter_category(query, categories) when is_list(categories) do
    where(query, [r, _c, _s], r.category in ^categories)
  end

  defp filter_category(query, category) do
    where(query, [r, _c, _s], r.category == ^category)
  end

 defp filter_status(query, status) when status in [nil, ""], do: query
  defp filter_status(query, []), do: query

  defp filter_status(query, statuses) when is_list(statuses) do
    where(query, [r, _c, _s], r.status in ^statuses)
  end

  defp filter_status(query, status) do
    where(query, [r, _c, _s], r.status == ^status)
  end

  defp filter_priority(query, priority) when priority in [nil, ""], do: query
  defp filter_priority(query, []), do: query

  defp filter_priority(query, priorities) when is_list(priorities) do
    where(query, [r, _c, _s], r.priority in ^priorities)
  end

  defp filter_priority(query, priority) do
    where(query, [r, _c, _s], r.priority == ^priority)
  end

  defp filter_date_range(query, date_from, date_to)
      when date_from in [nil, ""] and date_to in [nil, ""] do
    query
  end

  defp filter_date_range(query, date_from, date_to)
      when date_from not in [nil, ""] and date_to in [nil, ""] do
    {:ok, date} = Date.from_iso8601(date_from)

    datetime =
      DateTime.new!(date, ~T[00:00:00], "Etc/UTC")

    where(query, [r, _c, _s], r.inserted_at >= ^datetime)
  end

  defp filter_date_range(query, date_from, date_to)
      when date_from in [nil, ""] and date_to not in [nil, ""] do
    {:ok, date} = Date.from_iso8601(date_to)

    datetime =
      DateTime.new!(date, ~T[23:59:59], "Etc/UTC")

    where(query, [r, _c, _s], r.inserted_at <= ^datetime)
  end

  defp filter_date_range(query, date_from, date_to) do
    {:ok, from_date} = Date.from_iso8601(date_from)
    {:ok, to_date} = Date.from_iso8601(date_to)

    from_datetime =
      DateTime.new!(from_date, ~T[00:00:00], "Etc/UTC")

    to_datetime =
      DateTime.new!(to_date, ~T[23:59:59], "Etc/UTC")

    where(
      query,
      [r, _c, _s],
      r.inserted_at >= ^from_datetime and
        r.inserted_at <= ^to_datetime
    )
  end

  defp filter_customer(query, customer_id) when customer_id in [nil, ""], do: query

  defp filter_customer(query, customer_id) do
    where(query, [r, _c, _s], r.customer_id == ^customer_id)
  end

  defp filter_staff(query, staff_id) when staff_id in [nil, ""], do: query
  defp filter_staff(query, []), do: query

  defp filter_staff(query, staff_ids) when is_list(staff_ids) do
    where(query, [r, _c, _s], r.staff_id in ^staff_ids)
  end

  defp filter_staff(query, staff_id) do
    where(query, [r, _c, _s], r.staff_id == ^staff_id)
end




  def list_requests_by_customer(customer_id) do
    Request
    |> where([r], r.customer_id == ^customer_id)
    |> order_by([r], desc: r.inserted_at)
    |> Repo.all()
  end

  def get_request(request_id) do
    Repo.get(Request, request_id)
  end

  def get_request_for_customer(request_id, customer_id) do
    Request
    |> where([r], r.request_id == ^request_id and r.customer_id == ^customer_id)
    |> Repo.one()
  end

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def list_messages_for_request(request_id) do
    Message
    |> where([m], m.request_id == ^request_id)
    |> order_by([m], asc: m.inserted_at)
    |> Repo.all()
  end


  def list_messages_for_customer_request(request_id, customer_id) do
    Message
    |> join(:inner, [m], r in Request, on: r.request_id == m.request_id)
    |> where([m, r], m.request_id == ^request_id and r.customer_id == ^customer_id)
    |> order_by([m, _r], asc: m.inserted_at)
    |> Repo.all()
  end

  def create_customer_message(request_id, customer_id, body) do
    case get_request_for_customer(request_id, customer_id) do
      nil ->
        {:error, :unauthorized}

      _request ->
        case create_message(%{
              request_id: request_id,
              sender_type: "customer",
              sender_id: customer_id,
              body: body
            }) do
          {:ok, message} ->
            topic = "request:#{request_id}"

            IO.inspect(topic, label: "CUSTOMER BROADCAST TOPIC")

            result =
              Phoenix.PubSub.broadcast(
                PubSub,
                topic,
                {:new_message, message}
              )

            IO.inspect(result, label: "CUSTOMER BROADCAST RESULT")

            {:ok, message}

          error ->
            error
        end
    end
  end
end

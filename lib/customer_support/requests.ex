defmodule CustomerSupport.Requests do
  import Ecto.Query

  alias CustomerSupport.Repo
  alias CustomerSupport.Requests.Message
  alias CustomerSupport.Requests.Request

  def create_request(attrs) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
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
        create_message(%{
          request_id: request_id,
          sender_type: "customer",
          sender_id: customer_id,
          body: body
        })
    end
  end
end

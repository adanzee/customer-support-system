defmodule CustomerSupport.Requests do
  import Ecto.Query

  alias CustomerSupport.Repo
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
end

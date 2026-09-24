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
end

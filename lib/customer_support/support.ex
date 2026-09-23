defmodule CustomerSupport.Support do
  import Ecto.Query

  alias CustomerSupport.Repo
  alias CustomerSupport.Support.Request

  def list_customer_requests(customer_id) do
    Request
    |> where([r], r.customer_id == ^customer_id)
    |> order_by([r], desc: r.inserted_at)
    |> Repo.all()
  end

  def customer_request_counts(customer_id) do
    requests = list_customer_requests(customer_id)

    %{
      open: Enum.count(requests, &(&1.status == "Open")),
      in_progress: Enum.count(requests, &(&1.status == "In Progress")),
      waiting_for_customer:
        Enum.count(requests, &(&1.status == "Waiting for Customer")),
      resolved: Enum.count(requests, &(&1.status == "Resolved")),
      closed: Enum.count(requests, &(&1.status == "Closed")),
      reopened: Enum.count(requests, &(&1.status == "Reopened"))
    }
  end
end

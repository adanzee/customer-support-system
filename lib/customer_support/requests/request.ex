defmodule CustomerSupport.Requests.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :request_id, :string
    field :title, :string
    field :category, :string
    field :description, :string
    field :status, :string
    field :priority, :string

    belongs_to :customer, CustomerSupport.Accounts.Customer

    timestamps(type: :utc_datetime)
  end

  def changeset(request, attrs) do
    request
    |> cast(attrs, [
      :request_id,
      :title,
      :category,
      :description,
      :status,
      :priority,
      :customer_id
    ])
    |> validate_required([
      :title,
      :category,
      :description
    ])
  end
end

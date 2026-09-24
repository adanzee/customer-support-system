defmodule CustomerSupport.Requests.Request do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:request_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "requests" do
    field :title, :string
    field :description, :string
    field :category, :string
    field :status, :string, default: "Open"
    field :priority, :string, default: "Medium"

    belongs_to :customer, CustomerSupport.Accounts.Customer,
      foreign_key: :customer_id,
      references: :customer_id

    timestamps()
  end

  def changeset(request, attrs) do
    request
    |> cast(attrs, [:title, :description, :category, :status, :priority, :customer_id])
    |> validate_required([:title, :description, :category, :customer_id])
  end
end

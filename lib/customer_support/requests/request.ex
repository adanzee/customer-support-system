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

    belongs_to :customer, CustomerSupport.Accounts.Customer, foreign_key: :customer_id, references: :customer_id
    belongs_to :staff, CustomerSupport.SupportStaff.Staff, foreign_key: :staff_id, references: :staff_id

    has_many :messages, CustomerSupport.Requests.Message,
    foreign_key: :request_id,
    references: :request_id

    timestamps(type: :utc_datetime)
  end

  def changeset(request, attrs) do
    request
    |> cast(attrs, [:title, :description, :category, :status, :priority, :customer_id, :staff_id])
    |> validate_required([:title, :description, :category, :customer_id])
  end

  def valid_status_transition?(current_status, new_status) do
    case current_status do
      "Open" ->
        new_status == "In Progress"

      "In Progress" ->
        new_status in ["Waiting for Customer", "Resolved"]

      "Waiting for Customer" ->
        new_status in ["In Progress", "Resolved", "Closed"]

      "Resolved" ->
        new_status == "Closed"

      "Closed" ->
        new_status == "Reopened"

      "Reopened" ->
        new_status == "In Progress"

      _ ->
        false
    end
  end
end

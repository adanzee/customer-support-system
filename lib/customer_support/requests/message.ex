defmodule CustomerSupport.Requests.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:message_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "messages" do
    field :sender_type, :string
    field :sender_id, :binary_id
    field :body, :string

    belongs_to :request, CustomerSupport.Requests.Request,
      foreign_key: :request_id,
      references: :request_id

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:request_id, :sender_type, :sender_id, :body])
    |> validate_required([:request_id, :sender_type, :sender_id, :body])
  end
end

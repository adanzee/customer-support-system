defmodule CustomerSupport.Accounts.PasswordResetToken do
  use Ecto.Schema

  @primary_key {:token_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "password_reset_tokens" do
    field :token_hash, :string
    field :expires_at, :utc_datetime
    field :used_at, :utc_datetime

    belongs_to :customer, CustomerSupport.Accounts.Customer,
      foreign_key: :customer_id,
      references: :customer_id

    timestamps()
  end
end

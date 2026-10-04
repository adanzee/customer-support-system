defmodule CustomerSupport.SupportStaff.StaffPasswordResetToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "staff_password_reset_tokens" do
    field :token, :string
    field :expires_at, :utc_datetime

    belongs_to :staff, CustomerSupport.SupportStaff.Staff,
      foreign_key: :staff_id,
      references: :staff_id

    timestamps(type: :utc_datetime)
  end

  def changeset(reset_token, attrs) do
    reset_token
    |> cast(attrs, [:token, :staff_id, :expires_at])
    |> validate_required([:token, :staff_id, :expires_at])
    |> unique_constraint(:token)
  end
end

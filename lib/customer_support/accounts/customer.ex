defmodule CustomerSupport.Accounts.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias CustomerSupport.Requests.Request

  schema "customers" do

    field :full_name, :string
    field :email, :string
    field :phone_number, :string
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string, redact: true

    has_many :requests, Request

    timestamps(type: :utc_datetime)
  end

  def registration_changeset(customer, attrs) do
    customer
    |> cast(attrs, [:full_name, :email, :phone_number, :password])
    |> validate_required([:full_name, :email, :phone_number, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, required: true)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true} = changeset) do
    password = get_change(changeset, :password)

    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end

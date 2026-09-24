defmodule CustomerSupport.Accounts.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:customer_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "customers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def registration_changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :phone, :password, :password_confirmation])
    |> update_change(:email, &String.downcase/1)
    |> validate_required([:name, :email, :phone, :password, :password_confirmation])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, required: true)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end
end

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

    has_many :requests, CustomerSupport.Requests.Request,
    foreign_key: :customer_id,
    references: :customer_id

    timestamps()
  end

  def registration_changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :phone, :password, :password_confirmation])
    |> update_change(:email, &String.downcase/1)
    |> validate_required([:name, :email, :phone, :password, :password_confirmation])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password,
      required: true,
      message: "Passwords do not match"
    )
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def profile_changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :phone])
    |> update_change(:email, &String.downcase/1)
    |> validate_required([:name, :email, :phone])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
  end

  def password_changeset(customer, attrs) do
    customer
    |> password_validation_changeset(attrs)
    |> put_password_hash()
  end

  def password_validation_changeset(customer, attrs) do
    customer
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, required: true)
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true} = changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end

  defp put_password_hash(changeset), do: changeset
end

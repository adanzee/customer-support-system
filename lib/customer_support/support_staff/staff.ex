defmodule CustomerSupport.SupportStaff.Staff do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:staff_id, :binary_id, autogenerate: true}

  schema "support_staff" do
    field :staff_identifier, :string
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :status, :string, default: "active"

    timestamps(type: :utc_datetime)
  end

  def changeset(staff, attrs) do
    staff
    |> cast(attrs, [:staff_identifier, :name, :email, :password, :status])
    |> validate_required([:staff_identifier, :name, :email, :password])
    |> validate_length(:password, min: 8)
    |> hash_password()
    |> unique_constraint(:staff_identifier)
    |> unique_constraint(:email)
  end

  def update_changeset(staff, attrs) do
    staff
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end

  defp hash_password(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end

defmodule CustomerSupport.SupportUsers.SupportUser do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:support_user_id, :binary_id, autogenerate: true}

  schema "support_users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    field :role, Ecto.Enum,
      values: [:staff, :manager]

    timestamps(type: :utc_datetime)
  end

  def changeset(support_user, attrs) do
    support_user
    |> cast(attrs, [:name, :email, :password, :role])
    |> validate_required([:name, :email, :password, :role])
    |> validate_length(:password, min: 8)
    |> hash_password()
    |> unique_constraint(:email)
  end

  def update_changeset(support_user, attrs) do
    support_user
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

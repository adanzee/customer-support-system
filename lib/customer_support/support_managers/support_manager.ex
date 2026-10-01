defmodule CustomerSupport.SupportManagers.SupportManager do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:manager_id, :binary_id, autogenerate: true}

  schema "support_managers" do
    field :manager_identifier, :string
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(manager, attrs) do
    manager
    |> cast(attrs, [:manager_identifier, :name, :email, :password])
    |> validate_required([:manager_identifier, :name, :email, :password])
    |> validate_length(:password, min: 8)
    |> hash_password()
    |> unique_constraint(:manager_identifier)
    |> unique_constraint(:email)
  end

  defp hash_password(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end

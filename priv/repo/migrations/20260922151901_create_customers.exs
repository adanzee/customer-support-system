defmodule CustomerSupport.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do

    create table(:customers) do
      add :full_name, :string, null: false
      add :email, :string, null: false
      add :phone_number, :string, null: false
      add :password_hash, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:customers, [:email])
  end
end

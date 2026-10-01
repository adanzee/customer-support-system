defmodule CustomerSupport.Repo.Migrations.CreateSupportManagers do
  use Ecto.Migration

  def change do
    create table(:support_managers, primary_key: false) do
      add :manager_id, :binary_id, primary_key: true
      add :manager_code, :string, null: false
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:support_managers, [:manager_code])
    create unique_index(:support_managers, [:email])
  end
end

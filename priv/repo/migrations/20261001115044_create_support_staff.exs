defmodule CustomerSupport.Repo.Migrations.CreateSupportStaff do
  use Ecto.Migration

  def change do
    create table(:support_staff, primary_key: false) do
      add :staff_id, :binary_id, primary_key: true
      add :staff_code, :string, null: false
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:support_staff, [:staff_code])
    create unique_index(:support_staff, [:email])
  end
end

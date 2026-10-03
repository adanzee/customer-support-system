defmodule CustomerSupport.Repo.Migrations.AddStatusToSupportStaff do
  use Ecto.Migration

  def change do
    alter table(:support_staff) do
      add :status, :string, default: "active", null: false
    end
  end
end

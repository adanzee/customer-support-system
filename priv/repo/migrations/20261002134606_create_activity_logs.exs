defmodule CustomerSupport.Repo.Migrations.CreateActivityLogs do
  use Ecto.Migration

  def change do
    create table(:activity_logs, primary_key: false) do
      add :activity_id, :binary_id, primary_key: true

      add :action, :string, null: false
      add :description, :text, null: false

      add :entity_type, :string
      add :entity_id, :binary_id

      add :actor_type, :string
      add :actor_id, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:activity_logs, [:entity_type, :entity_id])
    create index(:activity_logs, [:actor_type, :actor_id])
    create index(:activity_logs, [:inserted_at])
  end
end

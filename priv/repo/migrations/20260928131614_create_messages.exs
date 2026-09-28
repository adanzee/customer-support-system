defmodule CustomerSupport.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :message_id, :binary_id, primary_key: true

      add :request_id,
        references(:requests, column: :request_id, type: :binary_id, on_delete: :delete_all), null: false

      add :sender_type, :string, null: false
      add :sender_id, :binary_id, null: false
      add :body, :text, null: false

      timestamps()
    end

    create index(:messages, [:request_id])
    create index(:messages, [:sender_id])
  end
end

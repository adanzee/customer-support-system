defmodule CustomerSupport.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests, primary_key: false) do
      add :request_id, :binary_id, primary_key: true

      add :customer_id,
          references(:customers, column: :customer_id, type: :binary_id, on_delete: :delete_all),
          null: false

      add :title, :string, null: false
      add :description, :text, null: false
      add :category, :string, null: false
      add :status, :string, null: false, default: "Open"
      add :priority, :string, null: false, default: "Medium"

      timestamps()
    end

    create index(:requests, [:customer_id])
  end
end

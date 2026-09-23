defmodule CustomerSupport.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :request_id, :string, null: false
      add :title, :string, null: false
      add :category, :string, null: false
      add :description, :text, null: false
      add :status, :string, null: false
      add :priority, :string

      add :customer_id,
          references(:customers, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:requests, [:request_id])
    create index(:requests, [:customer_id])
  end
end

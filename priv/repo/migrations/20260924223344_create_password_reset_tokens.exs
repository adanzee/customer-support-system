defmodule CustomerSupport.Repo.Migrations.CreatePasswordResetTokens do
  use Ecto.Migration

  def change do
    create table(:password_reset_tokens, primary_key: false) do
      add :token_id, :binary_id, primary_key: true

      add :customer_id,
          references(:customers,
            column: :customer_id,
            type: :binary_id,
            on_delete: :delete_all
          ),
          null: false

      add :token_hash, :string, null: false
      add :expires_at, :utc_datetime, null: false
      add :used_at, :utc_datetime

      timestamps()
    end

    create index(:password_reset_tokens, [:customer_id])
    create unique_index(:password_reset_tokens, [:token_hash])
  end
end

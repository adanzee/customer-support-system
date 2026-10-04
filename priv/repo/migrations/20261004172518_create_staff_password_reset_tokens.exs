defmodule CustomerSupport.Repo.Migrations.CreateStaffPasswordResetTokens do
  use Ecto.Migration

  def change do
    create table(:staff_password_reset_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :token, :string, null: false

      add :staff_id,
          references(:support_staff,
            column: :staff_id,
            type: :binary_id,
            on_delete: :delete_all
          ),
          null: false

      add :expires_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:staff_password_reset_tokens, [:token])
    create index(:staff_password_reset_tokens, [:staff_id])
  end
end

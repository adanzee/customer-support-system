defmodule CustomerSupport.Repo.Migrations.AddStaffToRequests do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :staff_id,
          references(:support_staff,
            column: :staff_id,
            type: :binary_id,
            on_delete: :nilify_all
          )
    end

    create index(:requests, [:staff_id])
  end
end

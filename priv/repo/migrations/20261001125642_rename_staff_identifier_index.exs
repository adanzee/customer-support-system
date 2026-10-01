defmodule CustomerSupport.Repo.Migrations.RenameStaffIdentifierIndex do
  use Ecto.Migration

  def change do
    execute(
      "ALTER INDEX support_staff_staff_code_index RENAME TO support_staff_staff_identifier_index",
      "ALTER INDEX support_staff_staff_identifier_index RENAME TO support_staff_staff_code_index"
    )
  end
end

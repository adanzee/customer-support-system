defmodule CustomerSupport.Repo.Migrations.RenameStaffAndManagerCodesToIdentifiers do
  use Ecto.Migration

  def change do
    rename table(:support_staff), :staff_code, to: :staff_identifier
    rename table(:support_managers), :manager_code, to: :manager_identifier
  end
end

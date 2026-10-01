defmodule CustomerSupport.Repo.Migrations.DropSupportUsers do
  use Ecto.Migration

  def change do
    drop table(:support_users)
  end
end

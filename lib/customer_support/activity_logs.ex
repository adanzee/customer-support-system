defmodule CustomerSupport.ActivityLogs do
  import Ecto.Query

  alias CustomerSupport.Repo
  alias CustomerSupport.ActivityLogs.ActivityLog

  def create_activity(attrs) do
    %ActivityLog{}
    |> ActivityLog.changeset(attrs)
    |> Repo.insert()
  end

  def list_recent_activities(limit \\ 10) do
    Repo.all(
      from a in ActivityLog,
        order_by: [desc: a.inserted_at],
        limit: ^limit
    )
  end
end

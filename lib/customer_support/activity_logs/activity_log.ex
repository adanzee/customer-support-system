defmodule CustomerSupport.ActivityLogs.ActivityLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:activity_id, :binary_id, autogenerate: true}

  schema "activity_logs" do
    field :action, :string
    field :description, :string
    field :entity_type, :string
    field :entity_id, :binary_id
    field :actor_type, :string
    field :actor_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(activity_log, attrs) do
    activity_log
    |> cast(attrs, [
      :action,
      :description,
      :entity_type,
      :entity_id,
      :actor_type,
      :actor_id
    ])
    |> validate_required([:action, :description])
  end
end

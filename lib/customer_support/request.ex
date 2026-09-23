defmodule CustomerSupport.Requests do
  alias CustomerSupport.Repo
  alias CustomerSupport.Requests.Request

  def create_request(attrs) do
    attrs = Map.put(attrs, :request_id, generate_request_id())

    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  defp generate_request_id do
    "REQ-" <> (:erlang.unique_integer([:positive]) |> Integer.to_string())
  end
end

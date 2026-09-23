defmodule CustomerSupport.Repo do
  use Ecto.Repo,
    otp_app: :customer_support,
    adapter: Ecto.Adapters.Postgres
end

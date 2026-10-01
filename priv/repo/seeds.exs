# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CustomerSupport.Repo.insert!(%CustomerSupport.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias CustomerSupport.SupportUsers

{:ok, _manager} =
  SupportUsers.create_support_user(%{
    name: "Support Manager",
    email: "manager@customersupport.com",
    password: "Manager@123",
    role: :manager
  })

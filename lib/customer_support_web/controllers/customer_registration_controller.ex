defmodule CustomerSupportWeb.CustomerRegistrationController do
  use CustomerSupportWeb, :controller


  def create(conn, %{"customer" => customer_params}) do
    IO.inspect(customer_params, label: "Registration Params")

    conn
    |> redirect(to: "/")
  end

end

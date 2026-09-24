defmodule CustomerSupportWeb.CustomerRegistrationController do
  use CustomerSupportWeb, :controller

  alias CustomerSupport.Accounts


  def create(conn, %{"customer" => customer_params}) do
    case Accounts.register_customer(customer_params) do
      {:ok, _customer} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: ~p"/login")

      {:error, changeset} ->
        # We'll handle validation errors properly with LiveView shortly.
        conn
        |> put_status(:unprocessable_entity)
        |> put_flash(:error, "Please correct the registration details.")
        |> redirect(to: ~p"/register")
    end
  end
end

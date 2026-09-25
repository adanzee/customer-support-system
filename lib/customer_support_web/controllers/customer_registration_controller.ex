defmodule CustomerSupportWeb.CustomerRegistrationController do
  use CustomerSupportWeb, :controller

  alias CustomerSupport.Accounts
  alias CustomerSupport.Mailer
  alias CustomerSupport.Mailers.CustomerMailer

  def create(conn, %{"customer" => customer_params}) do
    case Accounts.register_customer(customer_params) do
      {:ok, customer} ->
        customer
        |> CustomerMailer.registration_email()
        |> Mailer.deliver()

        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: ~p"/login")

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_flash(:error, "Please correct the registration details.")
        |> redirect(to: ~p"/register")
    end
  end
end

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

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_flash(:error, "Passwords do not match.")
        |> put_view(CustomerSupportWeb.CustomerRegistrationLive)
        |> Phoenix.Controller.render(:render, changeset: changeset)
    end
  end
end

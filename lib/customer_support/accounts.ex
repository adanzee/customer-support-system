defmodule CustomerSupport.Accounts do
  alias CustomerSupport.Accounts.Customer
  alias CustomerSupport.Repo

  def register_customer(attrs) do
    %Customer{}
    |> Customer.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get_customer_by_email(email) do
    Repo.get_by(Customer, email: String.downcase(email))
  end
  # does a customer with this email exist
  def authenticate_customer(email, password) do
    customer = get_customer_by_email(email)

    if customer && Bcrypt.verify_pass(password, customer.password_hash) do
      {:ok, customer}
    else
      {:error, :invalid_credentials}
    end
  end
end

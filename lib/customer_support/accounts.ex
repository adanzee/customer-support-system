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

  def get_customer(customer_id) do
    Repo.get(Customer, customer_id)
  end

 def update_customer(customer, attrs) do
    customer
    |> Customer.profile_changeset(attrs)
    |> Repo.update()
  end

  def change_password(customer, attrs) do
    if Bcrypt.verify_pass(attrs["current_password"], customer.password_hash) do
      password_attrs = %{
        "password" => attrs["new_password"],
        "password_confirmation" => attrs["new_password_confirmation"]
      }

      customer
      |> Customer.password_changeset(password_attrs)
      |> Repo.update()
    else
      {:error, :invalid_current_password}
    end
  end
end

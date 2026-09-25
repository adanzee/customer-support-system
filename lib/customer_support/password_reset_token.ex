defmodule CustomerSupport.PasswordResetToken do

  alias CustomerSupport.Repo
  alias CustomerSupport.Accounts.PasswordResetToken, as: Token
  alias CustomerSupport.Accounts.Customer

  def create_token(customer) do
      token = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)

      token_hash =
        :crypto.hash(:sha256, token)
        |> Base.encode16(case: :lower)

      attrs = %{
        customer_id: customer.customer_id,
        token_hash: token_hash,
        expires_at: DateTime.add(DateTime.utc_now(), 3600, :second)
      }

      %Token{}
      |> Ecto.Changeset.cast(attrs, [:customer_id, :token_hash, :expires_at])
      |> Ecto.Changeset.validate_required([
        :customer_id,
        :token_hash,
        :expires_at
      ])
      |> Repo.insert()
      |> case do
        {:ok, _token_record} ->
          {:ok, token}

        error ->
          error
      end
  end

  def verify_token(token) do
    token_hash =
      :crypto.hash(:sha256, token)
      |> Base.encode16(case: :lower)

    Token
    |> Repo.get_by(token_hash: token_hash)
    |> case do
      nil ->
        {:error, :invalid_token}

      reset_token ->
        cond do
          reset_token.used_at != nil ->
            {:error, :token_already_used}

          DateTime.compare(reset_token.expires_at, DateTime.utc_now()) != :gt ->
            {:error, :token_expired}

          true ->
            {:ok, reset_token}
        end
    end
  end

  def consume_token(reset_token) do
    used_at = DateTime.utc_now() |> DateTime.truncate(:second)

    reset_token
    |> Ecto.Changeset.change(used_at: used_at)
    |> Repo.update()
  end

  def reset_password(reset_token, attrs) do
    customer = Repo.get(Customer, reset_token.customer_id)

    changeset = Customer.password_changeset(customer, attrs)

    case Repo.update(changeset) do
      {:ok, customer} ->
        case consume_token(reset_token) do
          {:ok, _token} ->
            {:ok, customer}

          {:error, error} ->
            {:error, error}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end

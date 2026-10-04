defmodule CustomerSupport.SupportStaff.StaffPasswordReset do
  alias CustomerSupport.Repo
  alias CustomerSupport.SupportStaff
  alias CustomerSupport.SupportStaff.Staff
  alias CustomerSupport.SupportStaff.StaffPasswordResetToken

  @token_lifetime 3600

  def create_token(email) do
    case Repo.get_by(Staff, email: String.downcase(email)) do
      nil ->
        {:error, :not_found}

      staff ->
        token =
          :crypto.strong_rand_bytes(32)
          |> Base.url_encode64(padding: false)

        expires_at =
          DateTime.utc_now()
          |> DateTime.add(@token_lifetime, :second)

        %StaffPasswordResetToken{}
        |> StaffPasswordResetToken.changeset(%{
          token: token,
          staff_id: staff.staff_id,
          expires_at: expires_at
        })
        |> Repo.insert()
        |> case do
          {:ok, reset_token} ->
            {:ok, staff, reset_token}

          error ->
            error
        end
    end
  end

  def get_valid_token(token) do
    case Repo.get_by(StaffPasswordResetToken, token: token) do
      nil ->
        {:error, :invalid_token}

      reset_token ->
        if DateTime.compare(reset_token.expires_at, DateTime.utc_now()) == :gt do
          {:ok, reset_token}
        else
          {:error, :expired_token}
        end
    end
  end

  def reset_password(token, new_password) do
    case get_valid_token(token) do
      {:error, reason} ->
        {:error, reason}

      {:ok, reset_token} ->
        case SupportStaff.get_staff(reset_token.staff_id) do
          nil ->
            {:error, :staff_not_found}

          staff ->
            case staff
                 |> Staff.password_changeset(%{password: new_password})
                 |> Repo.update() do
              {:ok, updated_staff} ->
                Repo.delete(reset_token)
                {:ok, updated_staff}

              error ->
                error
            end
        end
    end
  end
end

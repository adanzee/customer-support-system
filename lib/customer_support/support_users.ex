defmodule CustomerSupport.SupportUsers do
  import Ecto.Query

  alias CustomerSupport.Repo
  alias CustomerSupport.SupportUsers.SupportUser

  def create_support_user(attrs) do
    %SupportUser{}
    |> SupportUser.changeset(attrs)
    |> Repo.insert()
  end

  def get_support_user(support_user_id) do
    Repo.get(SupportUser, support_user_id)
  end

  def get_support_user_by_email(email) do
    Repo.get_by(SupportUser, email: email)
  end


  def authenticate_support_user(email, password) do
    case get_support_user_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      support_user ->
        if Bcrypt.verify_pass(password, support_user.password_hash) do
          {:ok, support_user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def create_staff(attrs) do
    attrs
    |> Map.put("role", :staff)
    |> create_support_user()
  end


  def list_staff do
    SupportUser
    |> where([s], s.role == :staff)
    |> Repo.all()
  end

  def update_support_user(support_user, attrs) do
    support_user
    |> SupportUser.update_changeset(attrs)
    |> Repo.update()
  end
end

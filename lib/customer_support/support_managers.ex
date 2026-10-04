defmodule CustomerSupport.SupportManagers do
  alias CustomerSupport.Repo
  alias CustomerSupport.SupportManagers.SupportManager
  alias CustomerSupport.Mailers.StaffMailer
  alias CustomerSupport.Mailer

  def create_manager(attrs) do
    %SupportManager{}
    |> SupportManager.changeset(attrs)
    |> Repo.insert()
  end

  def get_manager(manager_id) do
    Repo.get(SupportManager, manager_id)
  end

  def get_manager_by_email(email) do
    Repo.get_by(SupportManager, email: email)
  end

  def authenticate_manager(email, password) do
    case get_manager_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      manager ->
        if Bcrypt.verify_pass(password, manager.password_hash) do
          {:ok, manager}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def list_managers do
    Repo.all(SupportManager)
  end
end

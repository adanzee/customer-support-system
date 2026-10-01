defmodule CustomerSupport.SupportStaff do

  alias CustomerSupport.Repo
  alias CustomerSupport.SupportStaff.Staff

  def create_staff(attrs) do
    %Staff{}
    |> Staff.changeset(attrs)
    |> Repo.insert()
  end

  def update_staff(staff, attrs) do
    staff
    |> Staff.update_changeset(attrs)
    |> Repo.update()
  end

  def list_staff do
    Repo.all(Staff)
  end

  def get_staff(staff_id) do
    Repo.get(Staff, staff_id)
  end

  def get_staff_by_email(email) do
    Repo.get_by(Staff, email: email)
  end

  def authenticate_staff(email, password) do
    case get_staff_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      staff ->
        if Bcrypt.verify_pass(password, staff.password_hash) do
          {:ok, staff}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end

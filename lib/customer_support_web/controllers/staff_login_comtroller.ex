defmodule CustomerSupportWeb.StaffLoginController do
  use CustomerSupportWeb, :controller

  alias CustomerSupport.SupportStaff

  def create(conn, %{"staff" => %{"email" => email, "password" => password}}) do
    case SupportStaff.authenticate_staff(email, password) do
      {:ok, staff} ->
        conn
        |> put_session(:staff_id, staff.staff_id)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: "/support/staff/dashboard")

      {:error, :account_disabled} ->
        conn
        |> put_flash(:error, "Your account has been disabled. Please contact your manager.")
        |> redirect(to: "/support/staff/login")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> redirect(to: "/support/staff/login")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:staff_id)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/support/staff/login")
  end
end

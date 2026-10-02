defmodule CustomerSupportWeb.StaffEditLive do
  use CustomerSupportWeb, :live_view

  on_mount {CustomerSupportWeb.ManagerAuthHook, :default}

  alias CustomerSupport.SupportStaff
  alias CustomerSupport.SupportStaff.Staff

  def mount(%{"id" => id}, _session, socket) do
    case SupportStaff.get_staff(id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Support staff not found.")
         |> push_navigate(to: ~p"/support/manager/staff")}

      staff ->
        changeset = Staff.update_changeset(staff, %{})

        {:ok,
         socket
         |> assign(:staff, staff)
         |> assign(:form, to_form(changeset))}
    end
  end

  def handle_event("update_staff", %{"staff" => params}, socket) do
    case SupportStaff.update_staff(socket.assigns.staff, params) do
      {:ok, _staff} ->
        {:noreply,
        socket
        |> put_flash(:info, "Support staff updated successfully.")
        |> push_navigate(to: ~p"/support/manager/staff")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Edit Support Staff</h1>

      <.form for={@form} phx-submit="update_staff">
        <div>
          <label>Name</label>
          <.input field={@form[:name]} type="text" />
        </div>

        <div>
          <label>Email</label>
          <.input field={@form[:email]} type="email" />
        </div>

        <button type="submit">Update Staff</button>
      </.form>

      <p>
        <.link navigate={~p"/support/manager/staff"}>
          Back to Staff
        </.link>
      </p>
    </div>
    """
  end
end

defmodule CustomerSupportWeb.StaffNewLive do
  use CustomerSupportWeb, :live_view

  alias CustomerSupport.SupportStaff
  alias CustomerSupport.SupportStaff.Staff

   on_mount {CustomerSupportWeb.ManagerAuthHook, :default}


  def mount(_params, _session, socket) do
    changeset = Staff.changeset(%Staff{}, %{})

    {:ok, assign(socket, form: to_form(changeset))}
  end

  def handle_event("create_staff", %{"staff" => params}, socket) do
    case SupportStaff.create_staff(params) do
      {:ok, _staff} ->
        {:noreply,
        socket
        |> put_flash(:info, "Support staff created successfully.")
        |> assign(
          form: to_form(Staff.changeset(%Staff{}, %{}))
        )}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Create Support Staff</h1>
      <p>
        <.link navigate={~p"/support/manager/staff"}>
          Back to Staff
        </.link>
      </p>

      <.form for={@form} phx-submit="create_staff">

          <div>
          <label>Staff Identifier</label>
          <.input field={@form[:staff_identifier]} type="text" />
         </div>

        <div>
          <label>Name</label>
          <.input field={@form[:name]} type="text" />
        </div>

        <div>
          <label>Email</label>
          <.input field={@form[:email]} type="email" />
        </div>

        <div>
          <label>Password</label>
          <.input field={@form[:password]} type="password" />
        </div>

        <button type="submit">Create Staff</button>
      </.form>
    </div>
    """
  end
end

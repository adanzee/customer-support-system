defmodule CustomerSupportWeb.StaffNewLive do
  use CustomerSupportWeb, :live_view

  on_mount {CustomerSupportWeb.SupportAuthHook, :default}
  on_mount {CustomerSupportWeb.SupportAuthHook, :manager}

  alias CustomerSupport.SupportUsers
  alias CustomerSupport.SupportUsers.SupportUser

  def mount(_params, _session, socket) do
    changeset = SupportUser.changeset(%SupportUser{}, %{})

    {:ok, assign(socket, form: to_form(changeset))}
  end

  def handle_event("create_staff", %{"support_user" => params}, socket) do
    case SupportUsers.create_staff(params) do
      {:ok, _staff} ->
        {:noreply,
        socket
        |> put_flash(:info, "Support staff created successfully.")
        |> assign(
          form: to_form(SupportUser.changeset(%SupportUser{}, %{}))
        )}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Create Support Staff</h1>

      <.form for={@form} phx-submit="create_staff">

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

defmodule CustomerSupport.SupportStaff do
  import Ecto.Query

  alias CustomerSupport.Repo
  alias CustomerSupport.SupportStaff.Staff
  alias CustomerSupport.Requests.Request
  alias CustomerSupport.Requests.Message
  alias CustomerSupport.PubSub
  alias CustomerSupport.ActivityLogs
  alias CustomerSupport.Mailers.CustomerMailer
  alias CustomerSupport.Mailer

 def create_staff(attrs) do
    case %Staff{}
        |> Staff.changeset(attrs)
        |> Repo.insert() do
      {:ok, staff} ->
        ActivityLogs.create_activity(%{
          action: "staff_created",
          description: "New support staff #{staff.name} was created.",
          entity_type: "staff",
          entity_id: staff.staff_id,
          actor_type: "manager"
        })

        {:ok, staff}

      error ->
        error
    end
  end

  def update_request_status(staff_id, request_id, new_status) do
    case Repo.get(Request, request_id) do
      nil ->
        {:error, :request_not_found}

      request ->
        cond do
          request.staff_id != staff_id ->
            {:error, :unauthorized}

          not Request.valid_status_transition?(request.status, new_status) ->
            {:error, :invalid_status_transition}

          true ->
            case request
                |> Ecto.Changeset.change(status: new_status)
                |> Repo.update() do

                {:ok, updated_request} ->
                  customer = CustomerSupport.Accounts.get_customer(updated_request.customer_id)

                  customer
                  |> CustomerMailer.request_status_changed_email(
                    updated_request,
                    request.status
                  )
                  |> Mailer.deliver()

                  Phoenix.PubSub.broadcast(
                    PubSub,
                    "request:#{request_id}",
                    {:status_updated, request_id, new_status}
                  )



                {:ok, updated_request}

              error ->
                error
            end
        end
    end
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
      {:error, :not_team_member}

    %{status: "disabled"} ->
      {:error, :account_disabled}

    staff ->
      if Bcrypt.verify_pass(password, staff.password_hash) do
        {:ok, staff}
      else
        {:error, :invalid_credentials}
      end
  end
end

 def delete_staff(staff) do
    case Repo.delete(staff) do
      {:ok, deleted_staff} ->
        ActivityLogs.create_activity(%{
          action: "staff_deleted",
          description: "Support staff #{deleted_staff.name} was deleted.",
          entity_type: "staff",
          entity_id: deleted_staff.staff_id,
          actor_type: "manager"
        })

        {:ok, deleted_staff}

      error ->
        error
    end
  end

  def list_assigned_requests(staff_id) do

    Repo.all(
      from r in Request,
        where: r.staff_id == ^staff_id,
        preload: [:customer]
    )
  end

  def disable_staff(staff_id) do
    case get_staff(staff_id) do
      nil ->
        {:error, :not_found}

      staff ->
        staff
        |> Ecto.Changeset.change(status: "disabled")
        |> Repo.update()
    end
  end

  def enable_staff(staff_id) do
    case get_staff(staff_id) do
      nil ->
        {:error, :not_found}

      staff ->
        staff
        |> Ecto.Changeset.change(status: "active")
        |> Repo.update()
    end
  end

  def get_assigned_request(staff_id, request_id) do


    Repo.one(
      from r in Request,
        where: r.request_id == ^request_id and r.staff_id == ^staff_id,
        preload: [:customer, :messages]
    )
  end

  def list_recent_staff(limit \\ 2) do
    Staff
    |> order_by([s], desc: s.inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end



  def count_staff do
    Repo.aggregate(Staff, :count, :staff_id)
  end



    def create_request_message(staff_id, request_id, body) do
    case get_assigned_request(staff_id, request_id) do
      nil ->
        {:error, :request_not_found}

      request ->
        request = Repo.preload(request, [:customer, :staff])

        case %Message{}
            |> Message.changeset(%{
              request_id: request.request_id,
              sender_type: "staff",
              sender_id: staff_id,
              body: body
            })
            |> Repo.insert() do
          {:ok, message} ->
            # Notify customer by email
           request.customer
            |> CustomerSupport.Mailers.CustomerMailer.staff_replied_email(
              request,
              body
            )
            |> CustomerSupport.Mailer.deliver()

            # Real-time notification
            topic = "request:#{request_id}"

            IO.inspect(topic, label: "STAFF BROADCAST TOPIC")

            result =
              Phoenix.PubSub.broadcast(
                PubSub,
                topic,
                {:new_message, message}
              )

            IO.inspect(result, label: "STAFF BROADCAST RESULT")

            {:ok, message}

          error ->
            error
        end
    end
  end
end

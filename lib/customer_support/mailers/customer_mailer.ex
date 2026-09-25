defmodule CustomerSupport.Mailers.CustomerMailer do
  import Swoosh.Email

  @from {"Customer Support", "no-reply@customer-support.local"}

  def registration_email(customer) do
    new()
    |> to(customer.email)
    |> from(@from)
    |> subject("Welcome to Customer Support")
    |> html_body("""
    #{email_layout("Welcome to Customer Support", """
    <p>Hello #{customer.name},</p>

    <p>
      Your Customer Support account has been successfully created.
    </p>

    <p>
      You can now log in to your account, submit support requests,
      and track their status.
    </p>

    #{notice("Thank you for creating an account with Customer Support.")}
    """)}
    """)
    |> text_body("""
    Hello #{customer.name},

    Welcome to Customer Support.

    Your Customer Support account has been successfully created.

    You can now log in to your account, submit support requests,
    and track their status.

    Thank you for creating an account with Customer Support.

    Customer Support
    """)
  end

  def password_reset_email(customer, token) do
    reset_url = "http://localhost:4000/reset-password/#{token}"

    new()
    |> to(customer.email)
    |> from(@from)
    |> subject("Reset your Customer Support password")
    |> html_body("""
    #{email_layout("Reset Your Password", """
    <p>Hello #{customer.name},</p>

    <p>
      We received a request to reset the password for your Customer Support account.
    </p>

    <p>
      Click the button below to create a new password.
    </p>

    #{button("Reset Password", reset_url)}

    #{notice("This link will expire in 1 hour.")}

    <p>
      If you did not request a password reset, you can safely ignore this email.
    </p>
    """)}
    """)
    |> text_body("""
    Hello #{customer.name},

    We received a request to reset your Customer Support password.

    Reset your password:
    #{reset_url}

    This link will expire in 1 hour.

    If you did not request a password reset, you can safely ignore this email.

    Customer Support
    """)
  end

  def request_submitted_email(customer, request) do
    new()
    |> to(customer.email)
    |> from(@from)
    |> subject("Your support request has been submitted")
    |> html_body("""
    #{email_layout("Request Submitted", """
    <p>Hello #{customer.name},</p>

    <p>
      Your support request has been successfully submitted.
    </p>

    #{request_details(request)}

    #{notice("Our support team will review your request and respond as soon as possible.")}
    """)}
    """)
    |> text_body("""
    Hello #{customer.name},

    Your support request has been successfully submitted.

    Request ID: #{request.request_id}
    Title: #{request.title}
    Category: #{request.category}
    Status: #{request.status}
    Priority: #{request.priority}

    Our support team will review your request and respond as soon as possible.

    Customer Support
    """)
  end

  def request_resolved_email(customer, request) do
    new()
    |> to(customer.email)
    |> from(@from)
    |> subject("Your support request has been resolved")
    |> html_body("""
    #{email_layout("Request Resolved", """
    <p>Hello #{customer.name},</p>

    <p>
      Your support request has been marked as resolved.
    </p>

    #{request_details(request)}

    #{notice("If you still need help, you can reopen the request or contact support.")}
    """)}
    """)
    |> text_body("""
    Hello #{customer.name},

    Your support request has been marked as resolved.

    Request ID: #{request.request_id}
    Title: #{request.title}
    Status: #{request.status}

    If you still need help, you can reopen the request or contact support.

    Customer Support
    """)
  end

  def request_status_changed_email(customer, request, old_status) do
    new()
    |> to(customer.email)
    |> from(@from)
    |> subject("Your support request status has changed")
    |> html_body("""
    #{email_layout("Request Status Updated", """
    <p>Hello #{customer.name},</p>

    <p>
      The status of your support request has been updated.
    </p>

    #{status_change_details(old_status, request.status)}

    #{request_details(request)}
    """)}
    """)
    |> text_body("""
    Hello #{customer.name},

    The status of your support request has changed.

    Request ID: #{request.request_id}
    Title: #{request.title}
    Previous status: #{old_status}
    New status: #{request.status}

    Customer Support
    """)
  end

  def request_priority_changed_email(customer, request, old_priority) do
    new()
    |> to(customer.email)
    |> from(@from)
    |> subject("Your support request priority has changed")
    |> html_body("""
    #{email_layout("Request Priority Updated", """
    <p>Hello #{customer.name},</p>

    <p>
      The priority of your support request has been updated.
    </p>

    #{priority_change_details(old_priority, request.priority)}

    #{request_details(request)}
    """)}
    """)
    |> text_body("""
    Hello #{customer.name},

    The priority of your support request has changed.

    Request ID: #{request.request_id}
    Title: #{request.title}
    Previous priority: #{old_priority}
    New priority: #{request.priority}

    Customer Support
    """)
  end

  def staff_replied_email(customer, request) do
    new()
    |> to(customer.email)
    |> from(@from)
    |> subject("Support staff replied to your request")
    |> html_body("""
    #{email_layout("New Support Reply", """
    <p>Hello #{customer.name},</p>

    <p>
      A member of our support team has replied to your request.
    </p>

    #{request_details(request)}

    #{button("View Request", "http://localhost:4000/requests/#{request.request_id}")}

    #{notice("Log in to your account to view the complete conversation.")}
    """)}
    """)
    |> text_body("""
    Hello #{customer.name},

    A member of our support team has replied to your request.

    Request ID: #{request.request_id}
    Title: #{request.title}

    View your request:
    http://localhost:4000/requests/#{request.request_id}

    Log in to your account to view the complete conversation.

    Customer Support
    """)
  end

  defp email_layout(title, content) do
    """
    <div style="background-color:#F5F0E9;padding:40px 20px;font-family:Arial,sans-serif;color:#112250;">
      <div style="max-width:600px;margin:0 auto;background:#ffffff;border-radius:10px;overflow:hidden;border:1px solid #D9CBC2;">

        <div style="background-color:#112250;padding:24px;text-align:center;">
          <h1 style="margin:0;color:#F5F0E9;font-size:24px;">
            Customer Support
          </h1>
        </div>

        <div style="padding:32px;">
          <h2 style="color:#112250;margin-top:0;">
            #{title}
          </h2>

          #{content}
        </div>

        <div style="background-color:#D9CBC2;padding:18px;text-align:center;">
          <p style="margin:0;color:#112250;font-size:13px;">
            Customer Support
          </p>
        </div>

      </div>
    </div>
    """
  end

  defp button(text, url) do
    """
    <p style="margin:28px 0;">
      <a href="#{url}"
         style="background-color:#E0C58F;
                color:#112250;
                padding:12px 22px;
                text-decoration:none;
                border-radius:6px;
                font-weight:bold;
                display:inline-block;">
        #{text}
      </a>
    </p>
    """
  end

  defp notice(text) do
    """
    <div style="background-color:#F5F0E9;border-left:4px solid #E0C58F;padding:14px;margin:20px 0;">
      <p style="margin:0;font-size:14px;">
        #{text}
      </p>
    </div>
    """
  end

  defp request_details(request) do
    """
    <div style="background-color:#F5F0E9;padding:18px;border-radius:6px;margin:20px 0;">
      <p><strong>Request ID:</strong> #{request.request_id}</p>
      <p><strong>Title:</strong> #{request.title}</p>
      <p><strong>Category:</strong> #{request.category}</p>
      <p><strong>Status:</strong> #{request.status}</p>
      <p><strong>Priority:</strong> #{request.priority}</p>
    </div>
    """
  end

  defp status_change_details(old_status, new_status) do
    """
    <div style="background-color:#F5F0E9;padding:18px;border-radius:6px;margin:20px 0;">
      <p>
        <strong>Previous Status:</strong> #{old_status}
      </p>
      <p>
        <strong>New Status:</strong> #{new_status}
      </p>
    </div>
    """
  end

  defp priority_change_details(old_priority, new_priority) do
    """
    <div style="background-color:#F5F0E9;padding:18px;border-radius:6px;margin:20px 0;">
      <p>
        <strong>Previous Priority:</strong> #{old_priority}
      </p>
      <p>
        <strong>New Priority:</strong> #{new_priority}
      </p>
    </div>
    """
  end
end

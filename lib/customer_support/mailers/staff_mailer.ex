defmodule CustomerSupport.Mailers.StaffMailer do
  import Swoosh.Email

  @from {"Customer Support", "no-reply@customer-support.local"}

  def request_assigned_email(staff, request) do
    new()
    |> to(staff.email)
    |> from(@from)
    |> subject("A support request has been assigned to you")
    |> html_body("""
    #{email_layout("Request Assigned", """
    <p>Hello #{staff.name},</p>

    <p>
      A support request has been assigned to you.
    </p>

    #{request_details(request)}

    #{notice("Please log in to the Support Staff portal to review and respond to the request.")}
    """)}
    """)
    |> text_body("""
    Hello #{staff.name},

    A support request has been assigned to you.

    Request ID: #{request.request_id}
    Title: #{request.title}
    Category: #{request.category}
    Status: #{request.status}
    Priority: #{request.priority}

    Please log in to the Support Staff portal to review and respond to the request.

    Customer Support
    """)
  end

  def request_reassigned_email(staff, request) do
    new()
    |> to(staff.email)
    |> from(@from)
    |> subject("A support request has been reassigned to you")
    |> html_body("""
    #{email_layout("Request Reassigned", """
    <p>Hello #{staff.name},</p>

    <p>
      A support request has been reassigned to you.
    </p>

    #{request_details(request)}

    #{notice("Please log in to the Support Staff portal to review and respond to the request.")}
    """)}
    """)
    |> text_body("""
    Hello #{staff.name},

    A support request has been reassigned to you.

    Request ID: #{request.request_id}
    Title: #{request.title}
    Category: #{request.category}
    Status: #{request.status}
    Priority: #{request.priority}

    Please log in to the Support Staff portal to review and respond to the request.

    Customer Support
    """)
  end

  def request_unassigned_email(staff, request) do
    new()
    |> to(staff.email)
    |> from(@from)
    |> subject("A support request is no longer assigned to you")
    |> html_body("""
    #{email_layout("Request Unassigned", """
    <p>Hello #{staff.name},</p>

    <p>
      The following support request is no longer assigned to you.
    </p>

    #{request_details(request)}

    #{notice("You no longer need to handle this request.")}
    """)}
    """)
    |> text_body("""
    Hello #{staff.name},

    The following support request is no longer assigned to you.

    Request ID: #{request.request_id}
    Title: #{request.title}
    Category: #{request.category}
    Status: #{request.status}
    Priority: #{request.priority}

    You no longer need to handle this request.

    Customer Support
    """)
  end

  def customer_replied_email(staff, request, customer, body) do
    new()
    |> to(staff.email)
    |> from(@from)
    |> subject("New message from customer on your support request")
    |> html_body("""
    #{email_layout("New Customer Message", """
    <p>Hello #{staff.name},</p>

    <p>
      #{customer.name} has sent a new message regarding a support request assigned to you.
    </p>

    #{request_details(request)}

    <p><strong>Customer message</strong></p>

    <div style="
      background-color: #f4f4f5;
      border-left: 4px solid #3b82f6;
      padding: 14px 16px;
      margin: 12px 0 20px;
      border-radius: 6px;
    ">
      <p style="margin: 0;">
        #{body}
      </p>
    </div>


    #{notice("Please log in to the support portal to respond to the customer.")}
    """)}
    """)
    |> text_body("""
    Hello #{staff.name},

    #{customer.name} has sent a new message regarding a support request assigned to you.

    Request ID: #{request.request_id}
    Title: #{request.title}
    Category: #{request.category}
    Status: #{request.status}
    Priority: #{request.priority}

    Customer message:
    #{body}

    Please log in to the support portal to respond to the customer.

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
end

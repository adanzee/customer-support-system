defmodule CustomerSupport.Mailers.StaffWelcomeMailer do
  import Swoosh.Email

  @from {"Customer Support", "no-reply@customersupport.local"}

  def welcome_email(staff, initial_password) do
    login_url = "http://localhost:4000/support/staff/login"

    new()
    |> to(staff.email)
    |> from(@from)
    |> subject("Your SupportDesk staff account")
    |> html_body("""
    <!DOCTYPE html>
    <html>
      <body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,sans-serif;color:#1f2937;">
        <div style="max-width:600px;margin:40px auto;background:#ffffff;border-radius:10px;overflow:hidden;border:1px solid #e5e7eb;">

          <div style="background:#111827;padding:28px 32px;color:#ffffff;">
            <h1 style="margin:0;font-size:24px;">SupportDesk</h1>
            <p style="margin:8px 0 0;color:#d1d5db;">Support Staff Account</p>
          </div>

          <div style="padding:32px;">
            <h2 style="margin-top:0;">Welcome, #{staff.name}!</h2>

            <p>
              Your SupportDesk staff account has been created by the support manager.
              You can use the credentials below to access the staff portal.
            </p>

            <div style="background:#f9fafb;border:1px solid #e5e7eb;border-radius:8px;padding:20px;margin:24px 0;">
              <p style="margin:0 0 12px;"><strong>Name:</strong> #{staff.name}</p>
              <p style="margin:0 0 12px;"><strong>Staff ID:</strong> #{staff.staff_identifier}</p>
              <p style="margin:0 0 12px;"><strong>Email:</strong> #{staff.email}</p>
              <p style="margin:0;"><strong>Initial Password:</strong> #{initial_password}</p>
            </div>

            <a href="#{login_url}"
               style="display:inline-block;background:#111827;color:#ffffff;text-decoration:none;padding:12px 22px;border-radius:6px;">
              Login to Staff Portal
            </a>

            <p style="margin-top:24px;color:#6b7280;font-size:14px;">
              For security, please change your password after your first login.
            </p>

            <p style="color:#6b7280;font-size:14px;">
              If you believe this account was created incorrectly, please contact your support manager.
            </p>
          </div>

          <div style="padding:20px 32px;background:#f9fafb;border-top:1px solid #e5e7eb;color:#6b7280;font-size:12px;">
            SupportDesk &mdash; Customer Support Management System
          </div>

        </div>
      </body>
    </html>
    """)
    |> text_body("""
    Welcome, #{staff.name}!

    Your SupportDesk staff account has been created.

    Account details:
    Name: #{staff.name}
    Staff ID: #{staff.staff_identifier}
    Email: #{staff.email}
    Initial Password: #{initial_password}

    Staff Portal:
    #{login_url}

    Please change your password after your first login.

    SupportDesk
    """)
  end
end

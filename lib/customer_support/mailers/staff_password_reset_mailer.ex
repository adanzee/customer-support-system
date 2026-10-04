defmodule CustomerSupport.Mailers.StaffPasswordResetMailer do
  import Swoosh.Email

  @from {"Customer Support", "no-reply@customersupport.local"}

  def password_reset_email(staff, reset_token) do
  reset_url =
    "http://localhost:4000/support/staff/reset-password/#{reset_token.token}"

  new()
  |> to(staff.email)
  |> from(@from)
  |> subject("Reset your SupportDesk password")
  |> html_body("""
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Reset your SupportDesk password</title>
    </head>

    <body style="margin:0; padding:0; background-color:#F5F0E9; font-family:Arial, Helvetica, sans-serif; color:#112250;">

      <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#F5F0E9; padding:40px 20px;">
        <tr>
          <td align="center">

            <table width="100%" cellpadding="0" cellspacing="0" border="0"
              style="max-width:560px; background-color:#FFFFFF; border:1px solid #D9CBC2; border-radius:16px; overflow:hidden;">

              <!-- HEADER -->
              <tr>
                <td style="background-color:#112250; padding:28px 32px; text-align:center;">

                  <div style="font-size:11px; letter-spacing:3px; font-weight:bold; color:#E0C58F; text-transform:uppercase;">
                    SupportDesk
                  </div>

                  <div style="margin-top:10px; font-size:24px; font-weight:700; color:#FFFFFF;">
                    Staff Portal
                  </div>

                </td>
              </tr>

              <!-- CONTENT -->
              <tr>
                <td style="padding:40px 36px;">

                  <div style="text-align:center; margin-bottom:28px;">
                    <div style="display:inline-block; background-color:#F5F0E9; border-radius:50%; padding:14px; font-size:24px;">
                      🔐
                    </div>
                  </div>

                  <h1 style="margin:0 0 16px; font-size:24px; line-height:1.3; color:#112250; text-align:center;">
                    Reset Your Password
                  </h1>

                  <p style="margin:0 0 18px; font-size:14px; line-height:1.7; color:#3C5070;">
                    Hello #{staff.name},
                  </p>

                  <p style="margin:0 0 18px; font-size:14px; line-height:1.7; color:#3C5070;">
                    We received a request to reset the password for your
                    SupportDesk staff account.
                  </p>

                  <p style="margin:0 0 28px; font-size:14px; line-height:1.7; color:#3C5070;">
                    Click the button below to create a new password and regain
                    access to the staff portal.
                  </p>

                  <!-- BUTTON -->
                  <div style="text-align:center; margin:32px 0;">

                    <a
                      href="#{reset_url}"
                      style="
                        display:inline-block;
                        background-color:#E0C58F;
                        color:#112250;
                        text-decoration:none;
                        font-size:13px;
                        font-weight:bold;
                        letter-spacing:1px;
                        padding:14px 28px;
                        border-radius:10px;
                      "
                    >
                      RESET PASSWORD →
                    </a>

                  </div>

                  <!-- EXPIRY NOTICE -->
                  <div style="background-color:#F5F0E9; border-left:4px solid #E0C58F; padding:14px 16px; margin-top:28px;">

                    <p style="margin:0; font-size:12px; line-height:1.6; color:#3C5070;">
                      <strong style="color:#112250;">Important:</strong>
                      This password reset link will expire in
                      <strong>1 hour</strong>.
                    </p>

                  </div>

                  <p style="margin:28px 0 0; font-size:12px; line-height:1.6; color:#7A879D;">
                    If you did not request a password reset, you can safely
                    ignore this email. Your current password will remain unchanged.
                  </p>

                  <!-- FALLBACK URL -->
                  <p style="margin:24px 0 0; font-size:11px; line-height:1.6; color:#94A3B8;">
                    If the button does not work, copy and paste this link into
                    your browser:
                  </p>

                  <p style="margin:6px 0 0; font-size:11px; line-height:1.6; word-break:break-all;">
                    <a
                      href="#{reset_url}"
                      style="color:#1D4ED8; text-decoration:none;"
                    >
                      #{reset_url}
                    </a>
                  </p>

                </td>
              </tr>

              <!-- FOOTER -->
              <tr>
                <td style="border-top:1px solid #E8DED7; padding:22px 32px; text-align:center;">

                  <p style="margin:0; font-size:10px; letter-spacing:2px; color:#94A3B8; text-transform:uppercase;">
                    Secure Gateway • SupportDesk
                  </p>

                  <p style="margin:8px 0 0; font-size:10px; color:#B0B7C3;">
                    This is an automated message. Please do not reply.
                  </p>

                </td>
              </tr>

            </table>

          </td>
        </tr>
      </table>

    </body>
  </html>
  """)
  |> text_body("""
  Hello #{staff.name},

  We received a request to reset the password for your SupportDesk staff account.

  Reset your password:
  #{reset_url}

  This password reset link will expire in 1 hour.

  If you did not request a password reset, you can safely ignore this email.
  Your current password will remain unchanged.

  SupportDesk
  """)
end
end

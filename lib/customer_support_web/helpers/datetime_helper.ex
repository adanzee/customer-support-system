defmodule CustomerSupportWeb.DateTimeHelper do
  def format_local(datetime) do
    datetime
    |> DateTime.shift_zone!("Asia/Karachi")
    |> Calendar.strftime("%b %d, %Y at %I:%M %p")
  end
end

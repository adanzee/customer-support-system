defmodule CustomerSupportWeb.PageController do
  use CustomerSupportWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

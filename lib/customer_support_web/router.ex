defmodule CustomerSupportWeb.Router do
  use CustomerSupportWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug CustomerSupportWeb.Plugs.CustomerAuth, :fetch_current_customer
    plug :fetch_live_flash
    plug :put_root_layout, html: {CustomerSupportWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CustomerSupportWeb do
    pipe_through :browser

    get "/login/session/:id", CustomerSessionController, :create
    post "/register", CustomerRegistrationController, :create


    delete "/logout", CustomerSessionController, :delete

    live "/", CustomerPortalLive
    live "/register", CustomerRegistrationLive
    live "/login", CustomerLoginLive
    live "/profile", CustomerProfileLive
    live "/requests/new", RequestNewLive


  end

  # Other scopes may use custom stacks.
  # scope "/api", CustomerSupportWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:customer_support, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CustomerSupportWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

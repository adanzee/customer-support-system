defmodule CustomerSupportWeb.Router do
  use CustomerSupportWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CustomerSupportWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :customer_auth do
    plug CustomerSupportWeb.Plugs.CustomerAuth
  end



  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CustomerSupportWeb do
    pipe_through :browser

    live "/", CustomerHomeLive
    post "/register", CustomerRegistrationController, :create
    post "/login", CustomerLoginController, :create
    post "/logout", CustomerLogoutController, :logout

    live "/register", CustomerRegistrationLive
    live "/login", CustomerLoginLive
    live "/forgot-password", CustomerForgotPasswordLive
    live "/reset-password/:token", CustomerResetPasswordLive
  end

  scope "/", CustomerSupportWeb do
    pipe_through [:browser, :customer_auth]

    live "/dashboard", CustomerDashboardLive
    live "/requests/new", RequestNewLive
    live "/requests", RequestIndexLive
    live "/requests/:id", RequestShowLive
    live "/profile", CustomerProfileLive
    live "/profile/edit", CustomerEditProfileLive
    live "/change-password", CustomerChangePasswordLive
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

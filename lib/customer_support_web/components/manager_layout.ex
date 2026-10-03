defmodule CustomerSupportWeb.ManagerLayout do
  use CustomerSupportWeb, :html

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def manager_layout(assigns) do
    ~H"""
    <div class="flex h-screen overflow-hidden bg-[#F8FAFC] text-[#0F172A] antialiased">

      <.sidebar current_path={@current_path} />

      <main class="flex-1 min-w-0 overflow-y-auto">
        <%= render_slot(@inner_block) %>
      </main>

    </div>
    """
  end

  defp sidebar(assigns) do
    ~H"""
    <CustomerSupportWeb.ManagerSidebar.sidebar
      current_path={@current_path}
    />
    """
  end
end

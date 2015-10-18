defmodule Stack do
  use Application

  def start(_type, _args) do
    Stack.Supervisor.start_link(Application.get_env(:stack, :initial_stack))
  end
end

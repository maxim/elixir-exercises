defmodule Stack.Supervisor do
  use Supervisor

  def start_link(initial_stack) do
    result = { :ok, sup } = Supervisor.start_link(__MODULE__, [initial_stack])
    start_workers(sup, initial_stack)
    result
  end

  def start_workers(sup, initial_stack) do
    { :ok, stack } =
      Supervisor.start_child(sup, worker(Stack.Stack, [initial_stack]))
    Supervisor.start_child(sup, supervisor(Stack.SubSupervisor, [stack]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end

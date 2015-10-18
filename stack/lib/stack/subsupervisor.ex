defmodule Stack.SubSupervisor do
  use Supervisor

  def start_link(stack_pid) do
    { :ok, _pid } = Supervisor.start_link(__MODULE__, stack_pid)
  end

  def init(stack_pid) do
    child_processes = [ worker(Stack.Server, [stack_pid]) ]
    supervise child_processes, strategy: :one_for_one
  end
end

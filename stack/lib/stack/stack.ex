defmodule Stack.Stack do
  use GenServer

  def start_link(initial_stack) do
    { :ok, _pid } = GenServer.start_link(__MODULE__, initial_stack)
  end

  def save_stack(pid, stack) do
    GenServer.cast pid, { :save_stack, stack }
  end

  def get_stack(pid) do
    GenServer.call pid, :get_stack
  end

  def handle_call(:get_stack, _client, current_stack) do
    { :reply, current_stack, current_stack }
  end

  def handle_cast({ :save_stack, stack }, _current_stack) do
    { :noreply, stack }
  end
end

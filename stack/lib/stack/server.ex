defmodule Stack.Server do
  use GenServer

  ## Public API

  def start_link(stack_pid) do
    { :ok, _pid } =
      GenServer.start_link(__MODULE__, stack_pid, name: __MODULE__)
  end

  def pop,         do: GenServer.call __MODULE__, :pop
  def push(value), do: GenServer.cast __MODULE__, { :push, value }

  ## GenServer implementation

  def init(stack_pid) do
    stack = Stack.Stack.get_stack stack_pid
    { :ok, { stack, stack_pid } }
  end

  def handle_call(:pop, _client, { stack, stack_pid }) do
    [ head | tail ] = stack
    { :reply, head, { tail, stack_pid } }
  end

  def handle_cast({ :push, value }, { stack, stack_pid }) do
    if is_integer(value) and value < 10 do
      System.halt(value)
    end

    { :noreply, { [ value | stack ], stack_pid } }
  end

  def terminate(_reason, { stack, stack_pid }) do
    Stack.Stack.save_stack stack_pid, stack
  end
end

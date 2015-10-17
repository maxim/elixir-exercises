defmodule Stack.Server do
  use GenServer

  ## Public API

  def start_link(initial_stack),
    do: GenServer.start_link(__MODULE__, initial_stack, name: __MODULE__)

  def pop,         do: GenServer.call __MODULE__, :pop
  def push(value), do: GenServer.cast __MODULE__, { :push, value }

  ## GenServer implementation

  def handle_call(:pop, _client, stack) do
    [ head | tail ] = stack
    { :reply, head, tail }
  end

  def handle_cast({ :push, value }, stack) do
    { :noreply, [ value | stack ] }
  end
end

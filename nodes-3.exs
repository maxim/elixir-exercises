defmodule Ticker do
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 0])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients, next_client_index) do
    client_count = length(clients)

    if next_client_index > (client_count - 1) do
      next_client_index = 0
    end

    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([ pid | clients ], next_client_index)
    after
      @interval ->
        IO.puts "tick"

        if client_count > 0 do
          next_client = clients |> Enum.at(next_client_index)
          send next_client, { :tick }
        end

        generator(clients, next_client_index + 1)
    end
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick } ->
        IO.puts "tock in client"
        receiver
    end
  end
end

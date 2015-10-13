defmodule Responder do
  def parrot do
    receive do
      { sender, token } ->
        send sender, { :ok, token }
        parrot
    end
  end
end

parrot1 = spawn(Responder, :parrot, [])
parrot2 = spawn(Responder, :parrot, [])

send parrot1, { self, "fred"  }
send parrot2, { self, "betty" }

receive do
  { :ok, token } -> IO.puts token
end

receive do
  { :ok, token } -> IO.puts token
end

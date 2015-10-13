defmodule Messenger do
  def send_message_to(pid) do
    send pid, "hello"
    raise "boom"
  end
end

defmodule Receiver do
  def trace_messages do
    receive do
      msg -> IO.inspect(msg)
      trace_messages
    end
  end
end

spawn_monitor(Messenger, :send_message_to, [self])
:timer.sleep(500)
Receiver.trace_messages

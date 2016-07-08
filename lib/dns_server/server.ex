defmodule DnsServer.Server do
  use GenServer
  require Logger
  alias DnsServer.Parser
  # Send request to server with $ dig @127.0.0.1 -p 5353 foo.com

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, _socket} = :gen_udp.open(5353, [:binary])
  end

  def handle_info({:udp, _socket, _ip, _port, data}, state) do
    Parser.parse_packet(data)
    {:noreply, state}
  end

  def handle_info({_, _socket}, state) do
    {:noreply, state}
  end
end

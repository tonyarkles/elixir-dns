defmodule DnsServer.Parser do
  require Logger
  def parse_packet(data) do
    Logger.info("Parsing data: #{inspect data}")
    <<
    id :: unsigned-integer-size(16),
    qr :: size(1),
    opcode :: unsigned-integer-size(4),
    aa :: size(1),
    tc :: size(1),
    rd :: size(1),
    ra :: size(1),
    z :: size(3),
    rcode :: size(4),
    rest :: binary
    >> = to_string(data)
    Logger.info("Data id(#{inspect id}) qr(#{inspect qr}), opcode(#{inspect opcode})")
  end
end

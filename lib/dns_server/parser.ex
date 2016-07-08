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
    qdcount :: unsigned-integer-size(16),
    ancount :: unsigned-integer-size(16),
    nscount :: unsigned-integer-size(16),
    arcount :: unsigned-integer-size(16),
    rest :: binary
    >> = data
    Logger.info("Data id(#{inspect id}) qr(#{inspect qr}), opcode(#{inspect opcode}) qdcount(#{inspect qdcount})")
    Logger.info("ancount #{inspect ancount} nscount #{inspect nscount} arcount #{inspect arcount}")
    {questions, rest} = parse_questions(rest, qdcount)
    Logger.info("Questions: #{inspect questions}")
    {answers, rest} = parse_answers(rest, ancount)
    Logger.info("Answers: #{inspect answers}")
    {nsresource, rest} = parse_nsresource(rest, nscount)
    Logger.info("NSResources: #{inspect nsresource}")
    {additional, rest} = parse_additional(rest, arcount)
  end

  def parse_questions(data, 0, acc) do
    {acc, data}
  end

  def parse_questions(data, qdcount, acc \\ []) do
    # Parse out labels
    {labels, data} = parse_labels(data)
    <<
    qtype :: unsigned-integer-size(16),
    qclass :: unsigned-integer-size(16),
    rest :: binary
    >> = data

    parse_questions(rest, qdcount - 1, acc ++ [%{labels: labels, type: qtype, class: qclass}])
  end

  # No further implementation for this yet
  def parse_answers(data, 0, acc \\ []) do
    {acc, data}
  end

  # No further implementation for this yet
  def parse_nsresource(data, 0, acc \\ []) do
    {acc, data}
  end

  def parse_additional(data, 0, acc \\ []) do
    {acc, data}
  end

  def parse_labels(label_string) do
    parse_labels(label_string, [])
  end

  def parse_labels(<<0 :: size(8), rest :: binary>>, acc) do
    {acc, rest}
  end

  def parse_labels(<<>>, acc) do
    acc
  end

  def parse_labels(label_string, acc) do 
    Logger.info("Parsing: #{inspect label_string}")
    << 
    length :: size(8),
    label :: binary-size(length),
    rest :: binary 
    >> = label_string

    parse_labels(rest, acc ++ [label])
  end

end

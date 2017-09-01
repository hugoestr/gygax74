defmodule Shell do

  def start() do
    answer = IO.gets ">" |> String.trim("\r\n")
    IO.write answer
    start()
  end
end

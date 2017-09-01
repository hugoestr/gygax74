defmodule CommandLine.Shell do

  def main(args) do
     {opts,_,_}= OptionParser.parse(args,switches: [shell: :string], aliases: [i: :shell])
    IO.inspect opts #here I just print the options 
    Shell.start
  end
end

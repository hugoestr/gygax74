defmodule Character do
  def roll_character do
    roll = roll_attributes()
    class = roll |> select_class  
    %{attributes: roll, class: class}
  end

  defp roll_attributes do
   [:strength, :intelligence, :wisdom, :dexterity, :constitution, :charisma] 
  |> Enum.map(fn attribute -> {attribute, Enum.random(3..18)} end)
  end 

  defp select_class(roll) do
    classes = %{strength: :fighter, intelligence: :wizard, 
                wisdom: :cleric, dexterity: :thief}
    attribute =
    roll
    |> Enum.take(4)
    |> max_attribute
    
    {:ok, class} = Map.fetch(classes, attribute)
    class
  end

  defp max_attribute(character) do
    {attribute, _} = max_value character, {:stub, 0}     
    attribute
  end


  defp max_value([], max), do: max 
  defp max_value([{attribute, value}|t], {max_a, max_v}) do
    cond do
      value > max_v -> max_value t, {attribute, value}
      true    -> max_value t, {max_a, max_v}
    end
  end

end


Character.roll_character 
|> IO.inspect

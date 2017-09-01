defmodule Character do
  def roll_character do
    roll = roll_attributes()
    class = roll |> select_class  
    
    prime_modifier = get_prime_modifier(class, roll)
    prime_bonus = get_prime_requisit_bonus(class, roll, prime_modifier)

    %{attributes: roll, 
      class: class, 
      prime_modifier: prime_modifier,
      prime_bonus:  prime_bonus
    
    }
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

  defp get_prime_modifier(:fighter, roll) do
    int = Keyword.get roll, :intelligence      
    wis = Keyword.get roll, :wisdom      

    div(max((int - 9), 0), 2) + div(max((wis - 9),0), 3) 
  end

  defp get_prime_modifier(:wizard, roll) do
    wis = Keyword.get roll, :wisdom      

    div(max((wis - 9),0), 2)
  end

  defp get_prime_modifier(:cleric, roll) do
    str = Keyword.get roll, :strength      
    int = Keyword.get roll, :intelligence      

    div(max((int - 9), 0), 2) + div(max((str - 9), 0) , 3)
  end

  defp get_prime_modifier(:thief, roll) do
    int = Keyword.get roll, :intelligence      
    wis = Keyword.get roll, :wisdom      

    div(max((int - 9),0), 2) + max((wis - 9), 0)
  end


  defp get_prime_requisit_bonus(class, roll, bonus) do
    attribute = Map.get(class_prime_requisite(), class) 
    score = Keyword.get(roll, attribute) + bonus

    cond do
      score >= 15 ->  10 
      score >= 13 ->   5
      score >= 9  ->   0
      score >= 7  -> -10
      true        -> -20 
    end
  end


  defp class_prime_requisite() do
    %{fighter: :strength, 
      wizard: :intelligence, 
      cleric: :wisdom,  
      thief: :dexterity
    }
  end
end


Character.roll_character 
|> IO.inspect

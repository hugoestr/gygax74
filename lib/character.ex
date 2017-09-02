defmodule Character do
  
  
  def roll_character(random \\ false) do
    roll = roll_attributes()
    class = select_class(roll, random)  
    
    prime_modifier = get_prime_modifier(class, roll)
    prime_bonus = get_prime_requisit_bonus(class, roll, prime_modifier)

    languages = total_languages(roll)
    mth_bonus = get_missle_to_hit_bonus(roll)
    max_hirelings = get_max_hirelings(roll)
    system_shock_survival = get_system_shock_survival(roll)

    %{attributes: roll, 
      class: class, 
      prime_modifier: prime_modifier,
      prime_bonus:  prime_bonus,
      total_languages: languages,
      missile_to_hit_bonus: mth_bonus,
      max_hirelings: max_hirelings,
      system_shock_survival: system_shock_survival,
      gp: (Enum.random(3..18) * 10)
    }
  end

  defp roll_attributes do
    CharacterTables.attributes()
    |> Enum.map(fn attribute -> {attribute, Enum.random(3..18)} end)
  end 

  defp select_class(roll, random) do
    if random do
      random_class()
    else
      optimized_class(roll) 
    end 
  end

  defp random_class() do
    Enum.random(CharacterTables.classes)
  end

  defp optimized_class(roll) do
    classes = CharacterTables.prime_requisite_classes()

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
    attribute = Map.get(CharacterTables.class_prime_requisite(), class) 
    score = Keyword.get(roll, attribute) + bonus

    cond do
      score >= 15 ->  10 
      score >= 13 ->   5
      score >= 9  ->   0
      score >= 7  -> -10
      true        -> -20 
    end
  end

  defp total_languages(roll) do
    int = Keyword.get roll, :intelligence   
    max((int - 10), 0) + 1  
  end

  defp get_missle_to_hit_bonus(roll) do
    dex = Keyword.get roll, :dexterity   
    
    cond do
      dex >= 13 ->  1
      dex >=  9 ->  0
      dex >=  3 -> -1
    end
  end


  defp get_max_hirelings(roll) do
    cha = Keyword.get roll, :charisma   
      
    cond do
      cha >=  18 ->  %{hirelings:  12, loyalty_base:  4}
      cha >=  16 ->  %{hirelings:   6, loyalty_base:  2}
      cha >=  13 ->  %{hirelings:   5, loyalty_base:  1}
      cha >=  10 ->  %{hirelings:   4, loyalty_base:  0}
      cha >=   7 ->  %{hirelings:   3, loyalty_base:  0}
      cha >=   5 ->  %{hirelings:   2, loyalty_base: -1}
      true       ->  %{hirelings:   1, loyalty_base: -2}
    end
  end

  defp get_system_shock_survival(roll) do
    con = Keyword.get roll, :constitution   
      
    cond do
      con >=  15 -> %{survial: 1,   bonus_per_dice:  1}
      con >=  13 -> %{survial: 1,   bonus_per_dice:  0}
      con >=   9 -> %{survial: 0.9, bonus_per_dice:  0}
      con >=   7 -> %{survial: 0.5, bonus_per_dice:  0}
      true       -> %{survial: 0,   bonus_per_dice: -1}
    end
  end

end


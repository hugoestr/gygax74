defmodule CharacterTables do

  def attributes do
    [:strength, 
     :intelligence, 
     :wisdom, 
     :dexterity, 
     :constitution, 
     :charisma]
  end

  def prime_requisite_classes do
    %{strength: :fighter, 
      intelligence: :wizard, 
      wisdom: :cleric, 
      dexterity: :thief}
  end

  def class_prime_requisite() do
    %{fighter: :strength, 
      wizard: :intelligence, 
      cleric: :wisdom,  
      thief: :dexterity
    }
  end

end

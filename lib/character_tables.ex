defmodule CharacterTables do

  def classes() do
    [:fighter, :wizard, :cleric, :thief]
  end

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

  def alignments() do
    [:law,
     :neutrality,
     :chaos]
  end

  def races do
    [:human, :dwarf, :elf, :hobbit]
  end

  def race_classes do
    %{
      human:  %{fighter:   0,
                 wizard:   0,
                 cleric:   0,
                  thief:   0},

      dwarf:  %{fighter:   6},

      elf:    %{fighter:   4,
                wizard:    8},

      hobbit: %{fighter:   4}
    }
  end

end

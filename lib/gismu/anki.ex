defmodule Gismu.Anki do
  alias Gismu.Anki.Template

  def generate_deck(db, template, sep \\ "\t") do
    for {word, prop} <- db do
      case Template.generate(template, Map.merge(prop, %{word: word})) do
        [{front, back}] -> [[front, sep, back], "\n"]
        [] -> []
      end
    end
    |> :erlang.iolist_to_binary()
  end
end

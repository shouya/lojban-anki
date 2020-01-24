defmodule Gismu do
  alias Gismu.Database
  alias Gismu.Anki

  def preset_template(:with_etymology) do
    ety = "<%= for {lang, w} <- etymology do %><%=w%>(<%=lang%>), <% end %>"

    Anki.Template.new(
      "<%= word %>",
      "<%= explanation %><br/>etymology: #{ety}",
      fn x -> x[:explanation] && x[:etymology] end
    )
  end

  def generate_anki(preset, output \\ "deck.tsv") do
    db = Database.from_parsers()
    deck = Anki.generate_deck(db, preset_template(preset))
    File.write(output, deck)
  end

  def main(args) do
    args
    |> OptionParser.parse(
      strict: [output: :string, template: :string],
      aliases: [o: :output, t: :template]
    )
    |> case do
      {[_, _] = opts, [], []} ->
        template = String.to_atom(opts[:template])
        output = opts[:output]
        generate_anki(template, output)

      _ ->
        print_help()
    end
  end

  def print_help do
    IO.puts("""
    Usage:
    """)
  end
end

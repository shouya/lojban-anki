defmodule Gismu.Anki.Template do
  defstruct [:front, :back, :filter]

  def new(front, back, filter \\ fn _ -> true end) do
    %__MODULE__{front: front, back: back, filter: filter}
  end

  def generate(template, entry) do
    if template.filter.(entry) do
      front = EEx.eval_string(template.front, Keyword.new(entry))
      back = EEx.eval_string(template.back, Keyword.new(entry))
      [{front, back}]
    else
      []
    end
  end
end

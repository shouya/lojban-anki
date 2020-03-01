defmodule Gismu.Anki.Template do
  @callback generate_header() :: binary()
  @callback generate_line(
              word :: binary(),
              detail :: map(),
              db :: any()
            ) :: binary() | nil
end

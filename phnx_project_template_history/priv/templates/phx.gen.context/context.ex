defmodule <%= inspect context.module %> do
  @moduledoc """
  The <%= context.name %> context.
  """

  import Ecto.Query, warn: false
  alias <%= inspect schema.repo %><%= schema.repo_alias %>
  alias <%= inspect schema.repo %><%= schema.repo_alias %>FieldLog
  alias <%= inspect schema.repo %><%= schema.repo_alias %>History

end

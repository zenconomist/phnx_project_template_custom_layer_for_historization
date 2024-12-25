defmodule PhnxProjectTemplateHistory.RepoHelpers do
  import Ecto.Query

  alias PhnxProjectTemplateHistory.Repo

  def get!(queryable, id) do
    Repo.one!(from q in queryable, where: q.id == ^id and is_nil(q.deleted_at))
  end

  def get_all(queryable) do
    Repo.all(from q in queryable, where: is_nil(q.deleted_at))
  end
end
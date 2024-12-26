# def list_users do
#   PhnxProjectTemplateHistory.ServiceLayer.get_all(PhnxProjectTemplateHistory.Accounts.User)
# end

# def get_user!(id) do
#   PhnxProjectTemplateHistory.ServiceLayer.get!(PhnxProjectTemplateHistory.Accounts.User, id)
# end

# def create_user(attrs \\ %{}) do
#   PhnxProjectTemplateHistory.ServiceLayer.create(PhnxProjectTemplateHistory.Accounts.User, attrs)
# end

# def update_user(%User{} = user, attrs) do
#   PhnxProjectTemplateHistory.ServiceLayer.update(user, attrs)
# end

# def delete_user(%User{} = user) do
#   PhnxProjectTemplateHistory.ServiceLayer.delete(user)

defmodule PhnxProjectTemplateHistory.Accounts do
  alias PhnxProjectTemplateHistory.Accounts.User
  alias PhnxProjectTemplateHistory.Repo
  alias PhnxProjectTemplateHistory.ServiceLayer


  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    ServiceLayer.get_all(PhnxProjectTemplateHistory.Accounts.User)
    # Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: ServiceLayer.get!(PhnxProjectTemplateHistory.Accounts.User, id) # Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    ServiceLayer.create(PhnxProjectTemplateHistory.Accounts.User, attrs)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    ServiceLayer.delete(user)
    #Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end

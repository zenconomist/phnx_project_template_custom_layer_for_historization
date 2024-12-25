defmodule PhnxProjectTemplateHistory.User do
  alias PhnxProjectTemplateHistory.User.Users

    def list_users do
      PhnxProjectTemplateHistory.ServiceLayer.get_all(PhnxProjectTemplateHistory.User.Users)
    end

  def get_users!(id) do
    PhnxProjectTemplateHistory.ServiceLayer.get!(PhnxProjectTemplateHistory.User.Users, id)
  end

  def create_users(attrs \\ %{}) do
    PhnxProjectTemplateHistory.ServiceLayer.create(PhnxProjectTemplateHistory.User.Users, attrs)
  end

  def update_users(%Users{} = users, attrs) do
    PhnxProjectTemplateHistory.ServiceLayer.update(users, attrs)
  end

  def delete_users(%Users{} = users) do
    PhnxProjectTemplateHistory.ServiceLayer.delete(users)
  end

    # alias PhnxProjectTemplateHistory.User.Users

    @doc """
    Returns the list of users.

    ## Examples

        iex> list_users()
        [%Users{}, ...]

    """
    # def list_users do
    #   Repo.all(Users)
    # end

    @doc """
    Gets a single users.

    Raises `Ecto.NoResultsError` if the Users does not exist.

    ## Examples

        iex> get_users!(123)
        %Users{}

        iex> get_users!(456)
        ** (Ecto.NoResultsError)

    """
    # def get_users!(id), do: Repo.get!(Users, id)

    @doc """
    Creates a users.

    ## Examples

        iex> create_users(%{field: value})
        {:ok, %Users{}}

        iex> create_users(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    # def create_users(attrs \\ %{}) do
    #   %Users{}
    #   |> Users.changeset(attrs)
    #   |> Repo.insert()
    # end

    @doc """
    Updates a users.

    ## Examples

        iex> update_users(users, %{field: new_value})
        {:ok, %Users{}}

        iex> update_users(users, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    # def update_users(%Users{} = users, attrs) do
    #   users
    #   |> Users.changeset(attrs)
    #   |> Repo.update()
    # end

    @doc """
    Deletes a users.

    ## Examples

        iex> delete_users(users)
        {:ok, %Users{}}

        iex> delete_users(users)
        {:error, %Ecto.Changeset{}}

    """
    # def delete_users(%Users{} = users) do
    #   Repo.delete(users)
    # end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking users changes.

    ## Examples

        iex> change_users(users)
        %Ecto.Changeset{data: %Users{}}

    """
    # def change_users(%Users{} = users, attrs \\ %{}) do
    #   Users.changeset(users, attrs)
    # end

  
  end

defmodule PhnxProjectTemplateHistory.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PhnxProjectTemplateHistory.Repo

  alias PhnxProjectTemplateHistory.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(from s in User, where: is_nil(s.deleted_at))
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
  def get_user!(id) do
    Repo.one!(from s in User, where: s.id == ^id and is_nil(s.deleted_at))
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
    def create_user(attrs \\ %{}) do
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert!()
        # |> log_changes(attrs, :create)
        |> insert_scd2_version()
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
    IO.puts("user:")
    IO.inspect(user)
    %PhnxProjectTemplateHistory.Accounts.User{id: id} = user
    IO.inspect("id: #{id}")
    old_record = get_user!(id)
    IO.inspect(old_record)

    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> log_changes(old_record, attrs, :update)
    |> mark_scd2_inactive()
    |> insert_scd2_version()
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
    # repo update the record's deleted_at field to the current time
    user
    |> User.changeset(%{deleted_at: DateTime.utc_now()})
    |> Repo.update()
    |> mark_scd2_inactive()

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



  defp log_changes(record, old_record, attrs, action) do
    # # iterate over the fields of the record recursively
    record
    |> record_changes(old_record)
    |> IO.inspect()
    # record = Repo.insert(%ChangeLog{table_name: "users", record_id: record.id, changes: changes, action: action})
    record
  end

    defp record_changes(record, old_record, changes \\ []) do
      # IO.puts("record from record_changes:")
      # IO.inspect(record)
      # IO.puts("old_record from record_changes:")
      # IO.inspect(old_record)

      # old_value = Map.get(old_record, :name)
      # new_value = Map.get(record, :name)
      # if old_value != new_value do
      #     # how to convert atom field to key in map?
      #     # field = String.to_atom(field)
      #     changes = %{"name" => {old_value, new_value}}
      # end

      # old_value = Map.get(old_record, :email)
      # new_value = Map.get(record, :email)
      # if old_value != new_value do
      #     # how to convert atom field to key in map?
      #     # field = String.to_atom(field)
      #     changes = %{"email" => {old_value, new_value}}
      # end

      %PhnxProjectTemplateHistory.Accounts.User{password: old_value} = old_record
      {:ok, %PhnxProjectTemplateHistory.Accounts.User{password: new_value}} = record
      if old_value != new_value do
          # how to convert atom field to key in map?
          # field = String.to_atom(field)
          changes = %{"password" => {old_value, new_value}}
      end

      changes
    end



  defp insert_scd2_version(record) do
    # Implement logic to insert into SCD2 history table
    record
  end

  defp mark_scd2_inactive(record) do
    # Implement logic to mark SCD2 record as inactive
    record
  end
end

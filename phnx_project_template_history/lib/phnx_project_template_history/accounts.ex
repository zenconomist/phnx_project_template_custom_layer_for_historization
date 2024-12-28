defmodule PhnxProjectTemplateHistory.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PhnxProjectTemplateHistory.Repo


  alias PhnxProjectTemplateHistory.Accounts.User
  alias PhnxProjectTemplateHistory.Accounts.UserFieldLog
  alias PhnxProjectTemplateHistory.Accounts.UserHistory

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
        old_record = %User{}

        %User{}
        |> User.changeset(attrs)
        |> Repo.insert!()
        |> log_changes(old_record, :create)
        |> scd2_historize(:create)
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
    %User{id: id} = user
    old_record = get_user!(id)

    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> log_changes(old_record, :update)
    |> scd2_historize(:update)
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
    old_record = %User{}

    # repo update the record's deleted_at field to the current time
    user
    |> User.changeset(%{deleted_at: DateTime.utc_now()})
    |> Repo.update()
    |> log_changes(old_record, :update)
    |> scd2_historize(:delete)

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

  ## this needs refactoring -> if create and delete, only log action, and on create, the new values, on delete, only log the action.
  defp log_changes(record, old_record, action) do
    case action do
      :create ->
        old_record = %User{}
        record
        |> track_record_changes(old_record)
        |> create_change_log(record, action)
        # |> Logger.info("Created user: #{inspect record}")
      :update ->
        {:ok, new_record} = record
        new_record
        |> track_record_changes(old_record)
        |> create_change_log(record, action)
        # |> Logger.info("Updated user: #{inspect record}")
      :delete ->
        %{}
        |> create_change_log(record, action)
        # Logger.info("Deleted user: #{inspect record}")
    end
    record
  end

    defp track_record_changes(record, old_record, changes \\ %{}) do

            old_value = Map.get(old_record, :name)
            new_value = Map.get(record, :name)
            # update changes if not equal, else no update
            changes =
              cond do
                old_value != new_value ->
                  Map.put(changes, "name", {"old value: #{old_value}", "new_value: #{new_value}"})
                true ->
                  changes
              end

            old_value = Map.get(old_record, :email)
            new_value = Map.get(record, :email)
            # update changes if not equal, else no update
            changes =
              cond do
                old_value != new_value ->
                  Map.put(changes, "email", {"old value: #{old_value}", "new_value: #{new_value}"})
                true ->
                  changes
              end

            old_value = Map.get(old_record, :username)
            new_value = Map.get(record, :username)
            # update changes if not equal, else no update
            changes =
              cond do
                old_value != new_value ->
                  Map.put(changes, "username", {"old value: #{old_value}", "new_value: #{new_value}"})
                true ->
                  changes
              end

            old_value = Map.get(old_record, :phone)
            new_value = Map.get(record, :phone)
            # update changes if not equal, else no update
            changes =
              cond do
                old_value != new_value ->
                  Map.put(changes, "phone", {"old value: #{old_value}", "new_value: #{new_value}"})
                true ->
                  changes
              end

            old_value = Map.get(old_record, :password)
            new_value = Map.get(record, :password)
            # update changes if not equal, else no update
            changes =
              cond do
                old_value != new_value ->
                  Map.put(changes, "password", {"old value: #{old_value}", "new_value: #{new_value}"})
                true ->
                  changes
              end

      changes
    end


    defp create_change_log(changes, record, action) do
      IO.puts("Changes: #{inspect changes}")
      IO.puts("Record: #{inspect record}")
      IO.puts("Action: #{inspect action}")
      attrs =
        case action do
          :create ->
            Enum.map(changes, fn change ->
              %{
                table_name: "users",
                row_id: record.id,
                action: action,
                field_name: change.key,
                old_value: nil,
                new_value: change.value,
                time_of_change: DateTime.utc_now(),
                changed_by: "system"
              }
            end)
          :update ->
            case changes do
              %{} -> %{}
              _ ->
                Enum.map(changes, fn change ->
                  IO.inspect(change)
                  {old_val, new_val} = change
                  [
                    table_name: "users",
                    row_id: Map.get(record, :id),
                    action: action,
                    field_name: change.key,
                    old_value: old_val,
                    new_value: new_val,
                    time_of_change: DateTime.utc_now(),
                    changed_by: "system"
                  ]
                end)
            end
          :delete ->
            [
              table_name: "users",
              row_id: record.id,
              action: action,
              field_name: nil,
              old_value: nil,
              new_value: nil,
              time_of_change: DateTime.utc_now(),
              changed_by: "system"
            ]
          end
      IO.inspect(attrs)
      %UserFieldLog{}
      |> UserFieldLog.changeset(attrs)
      |> IO.inspect()
      |> Repo.insert()
    end

  defp scd2_historize(record, action) do
    # Implement logic to insert into SCD2 history table
    record
  end
end

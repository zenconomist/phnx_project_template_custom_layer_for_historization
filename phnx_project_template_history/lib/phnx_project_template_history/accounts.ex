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

        new_record =
          %User{}
          |> User.changeset(attrs)
          |> Repo.insert!()
          |> log_changes(old_record, :create)
          |> scd2_historize(attrs, :create)

        {:ok, new_record}
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
    |> scd2_historize(attrs, :update)
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
    |> log_changes(old_record, :delete)
    |> scd2_historize([], :delete)

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
            Map.put(changes, "name", {old_value, new_value})
          true ->
            changes
        end

      old_value = Map.get(old_record, :email)
      new_value = Map.get(record, :email)
      # update changes if not equal, else no update
      changes =
        cond do
          old_value != new_value ->
            Map.put(changes, "email", {old_value, new_value})
          true ->
            changes
        end

      old_value = Map.get(old_record, :username)
      new_value = Map.get(record, :username)
      # update changes if not equal, else no update
      changes =
        cond do
          old_value != new_value ->
            Map.put(changes, "username", {old_value, new_value})
          true ->
            changes
        end

      old_value = Map.get(old_record, :phone)
      new_value = Map.get(record, :phone)
      # update changes if not equal, else no update
      changes =
        cond do
          old_value != new_value ->
            Map.put(changes, "phone", {old_value, new_value})
          true ->
            changes
        end

      old_value = Map.get(old_record, :password)
      new_value = Map.get(record, :password)
      # update changes if not equal, else no update
      changes =
        cond do
          old_value != new_value ->
            Map.put(changes, "password", {old_value, new_value})
          true ->
            changes
        end

      changes
    end


    defp create_change_log(changes, record, action) do
      cond do
        changes == %{} && action != :delete ->
          IO.puts("No changes to log")
        true ->
            case action do
              :create ->
                Enum.map(changes, fn {key, value} ->
                  {_old_val, new_val} = value
                  %{
                    table_name: "users",
                    row_id: Map.get(record, :id),
                    action: Atom.to_string(action),
                    field_name: key,
                    old_value: "N/A",
                    new_value: new_val,
                    time_of_change: DateTime.utc_now(),
                    changed_by: "system"
                  } |> log_changes_in_repo()
                end)
              :update ->
                {:ok, new_record} = record
                Enum.map(changes, fn {key, value} ->
                  {old_val, new_val} = value
                  %{
                    table_name: "users",
                    row_id: Map.get(new_record, :id),
                    action: Atom.to_string(action),
                    field_name: key,
                    old_value: old_val,
                    new_value: new_val,
                    time_of_change: DateTime.utc_now(),
                    changed_by: "system"
                  } |> log_changes_in_repo()
                end)
              :delete ->
                {:ok, new_record} = record
                # no need for Enum.map as there is only one record - no changes tracked
                %{
                  table_name: "users",
                  row_id: Map.get(new_record, :id),
                  action: Atom.to_string(action),
                  field_name: "N/A",
                  old_value: "N/A",
                  new_value: "N/A",
                  time_of_change: DateTime.utc_now(),
                  changed_by: "system"
                } |> log_changes_in_repo()
            end # end of case action
      end # end of cond
          record
    end

    defp log_changes_in_repo(attrs) do
      %UserFieldLog{}
      |> UserFieldLog.changeset(attrs)
      |> Repo.insert()
    end

  defp scd2_historize(record, attrs, action) do
    last_date = ~U[2099-12-31 23:59:59Z]
    case action do

      :create ->
        extended_attrs = attrs
        |> Map.put(:entity_id, Map.get(record, :id))
        |> Map.put(:dat_from, DateTime.utc_now())
        |> Map.put(:dat_to, last_date)
        |> Map.put(:is_current, true)
        |> Map.put(:is_deleted, false)
        |> Map.put(:time_of_change, DateTime.utc_now())
        |> Map.put(:changed_by, "system")
        |> Enum.into(%{}, fn {k, v} -> {String.to_atom(to_string(k)), v} end)  # Ensure all keys are atoms

        %UserHistory{}
        |> UserHistory.changeset(extended_attrs)
        |> IO.inspect()
        |> Repo.insert()

      :update ->
        {:ok, updated_scd1_record} = record

        # Update the current record to be non-current
        Repo.one(from s in UserHistory, where: s.entity_id == ^Map.get(updated_scd1_record, :id) and s.is_current == true)
          |> UserHistory.changeset(%{dat_to: DateTime.utc_now(), is_current: false, is_deleted: false, changed_by: "system", time_of_change: DateTime.utc_now()})
          |> Repo.update()

        # Insert a new record with the updated values
          extended_attrs = attrs
          |> Map.put(:entity_id, Map.get(updated_scd1_record, :id))
          |> Map.put(:dat_from, DateTime.utc_now())
          |> Map.put(:dat_to, last_date)
          |> Map.put(:is_current, true)
          |> Map.put(:is_deleted, false)
          |> Map.put(:time_of_change, DateTime.utc_now())
          |> Map.put(:changed_by, "system")
          |> Enum.into(%{}, fn {k, v} -> {String.to_atom(to_string(k)), v} end)  # Ensure all keys are atoms

          %UserHistory{}
          |> UserHistory.changeset(extended_attrs)
          |> Repo.insert()

      :delete ->
        {:ok, updated_scd1_record} = record

        Repo.one(from s in UserHistory, where: s.entity_id == ^Map.get(updated_scd1_record, :id) and s.is_current == true)
          |> UserHistory.changeset(%{dat_to: DateTime.utc_now(), is_current: false, is_deleted: true, changed_by: "system", time_of_change: DateTime.utc_now(), deleted_at: DateTime.utc_now()})
          |> Repo.update()
    end

    record
  end
end

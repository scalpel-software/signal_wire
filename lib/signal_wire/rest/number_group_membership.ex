defmodule SignalWire.NumberGroupMembership do 
  @moduledoc """
  Represents a Number Group Membership resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-all-number-group-memberships)
  """

  import SignalWire.Utils

  @list_url "/api/relay/rest/number_groups/:number_group_id/number_group_memberships"
  @find_url "/api/relay/rest/number_group_memberships/:id"

  defstruct [:id, :number_group_id, :phone_number]

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(number_group_id, query \\ %{}) do 
    list(SignalWire.client(), number_group_id, query)
  end

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, number_group_id, query) do 
    case Tesla.get!(client, build_url(@list_url, [number_group_id: number_group_id], query)) do
      %Tesla.Env{body: %{"data" => data, "links" => links}, status: 200} -> 
        {:ok, as_struct(__MODULE__, data), rest_paging(links)}

      response -> 
        {:error, response}
    end
  end

  @spec find(binary) :: SignalWire.success() | SignalWire.error()
  def find(id), do: find(SignalWire.client(), id)

  @spec find(Tesla.Client.t(), binary) :: SignalWire.success() | SignalWire.error()
  def find(client, id) do 
    case Tesla.get!(client, build_url(@find_url, [id: id])) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec create(binary, map) :: SignalWire.success() | SignalWire.error()
  def create(number_group_id, params \\ %{}) do 
    create(SignalWire.client(), number_group_id, params)
  end

  @spec create(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def create(client, number_group_id, params) do 
    case Tesla.post!(client, build_url(@list_url, [number_group_id: number_group_id]), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec delete(binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(id), do: delete(SignalWire.client(), id)

  @spec delete(Tesla.Client.t(), binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, id) do 
    case Tesla.delete!(client, build_url(@find_url, [id: id])) do
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end
end

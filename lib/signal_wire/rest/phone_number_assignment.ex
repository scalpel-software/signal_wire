defmodule SignalWire.PhoneNumberAssignment do 
  @moduledoc """
  Represents a Phone Number Assignment resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-all-phone-number-assignments)
  """

  import SignalWire.Utils

  @url "/api/relay/rest/registry/beta/campaigns/:id/numbers"
  @delete_url "/api/relay/rest/registry/beta/numbers/:id"

  defstruct [
    :id,
    :state,
    :campaign_id,
    :phone_number,
    :status,
    :created_at,
    :updated_at
  ]

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(id, query \\ %{}), do: list(SignalWire.client(), id, query)

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, id, query) do 
    case Tesla.get!(client, build_url(@url, [id: id], query)) do
      %Tesla.Env{body: %{"data" => data, "links" => links}, status: 200} -> 
        {:ok, as_struct(__MODULE__, data), rest_paging(links)}

      response -> 
        {:error, response}
    end
  end

  @spec delete(binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(id), do: delete(SignalWire.client(), id)

  @spec delete(Tesla.Client.t(), binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, id) do 
    case Tesla.delete!(client, build_url(@delete_url, [id: id])) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end
end

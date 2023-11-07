defmodule SignalWire.Account do
  @moduledoc """
  Represents an Account resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-accounts)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts"

  defstruct [
    :sid,
    :owner_account_sid,
    :date_created,
    :date_updated,
    :friendly_name,
    :type,
    :status,
    :auth_token,
    :uri,
    :subresource_uris
  ]

  @spec list(map) :: SignalWire.success_list() | SignalWire.error()
  def list(query \\ %{}), do: list(SignalWire.client(), query)

  @spec list(Tesla.Client.t(), map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, query) do 
    case Tesla.get!(client, build_url(@url, [], query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, as_struct(__MODULE__, Map.get(body, "accounts", [])), paging(body)}

      response -> 
        {:error, response}
    end
  end

  @spec find(binary) :: SignalWire.success() | SignalWire.error()
  def find(id), do: find(SignalWire.client(), id)

  @spec find(Tesla.Client.t(), binary) :: SignalWire.success() | SignalWire.error()
  def find(client, id) do
    case Tesla.get!(client, record_url(id)) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec create(map) :: SignalWire.success() | SignalWire.error()
  def create(params), do: create(SignalWire.client(), params)

  @spec create(Tesla.Client.t(), map) :: SignalWire.success() | SignalWire.error()
  def create(client, params) do 
    case Tesla.post!(client, @url, params) do 
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec update(binary, map) :: SignalWire.success() | SignalWire.error()
  def update(id, params), do: update(SignalWire.client(), id, params) 
  
  @spec update(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, id, params) do 
    case Tesla.post!(client, record_url(id), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  defp record_url(account_id) do 
    build_url(@url <> "/:account_id", [account_id: account_id])
  end
end

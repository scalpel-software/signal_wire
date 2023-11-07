defmodule SignalWire.Media do 
  @moduledoc """
  Represents a Media resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-all-media)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/Messages/:message_id/Media"

  defstruct [
    :account_sid,
    :content_type,
    :date_created,
    :date_updated,
    :parent_sid,
    :sid,
    :uri
  ]

  @spec list(binary, binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(account_id, message_id, query \\ %{}) do 
    list(SignalWire.client(), account_id, message_id, query)
  end

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, account_id, message_id, query) do 
    case Tesla.get!(client, url_for(account_id, message_id, query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, 
          as_struct(__MODULE__, Map.get(body, "media_list", [])), 
          paging(body)
        }

      response -> 
        {:error, response}
    end
  end

  @spec find(binary, binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(account_id, message_id, sid) do
    find(SignalWire.client(), account_id, message_id, sid)
  end

  @spec find(Tesla.Client.t(), binary, binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(client, account_id, message_id, sid) do 
    case Tesla.get!(client, record_url(account_id, message_id, sid)) do
      %Tesla.Env{body: record, status: 200} -> 
        {:ok, as_struct(__MODULE__, record)}

      response -> 
        {:error, response}
    end
  end

  @spec delete(binary, binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(account_id, message_id, sid) do 
    delete(SignalWire.client(), account_id, message_id, sid)
  end

  @spec delete(Tesla.Client.t(), binary, binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, account_id, message_id, sid) do 
    case Tesla.delete!(client, record_url(account_id, message_id, sid)) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end

  defp url_for(account_id, message_id, query) do 
    build_url(@url, [account_id: account_id, message_id: message_id], query)
  end

  defp record_url(account_id, message_id, sid) do 
    build_url(@url <> "/:sid", [
      account_id: account_id, 
      message_id: message_id,
      sid: sid
    ])
  end
end

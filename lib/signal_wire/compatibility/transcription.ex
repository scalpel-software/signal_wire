defmodule SignalWire.Transcription do 
  @moduledoc """
  Represents a Transcription resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-all-transcriptions)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/Transcriptions"

  defstruct [
    :account_sid,
    :date_created,
    :date_updated,
    :duration,
    :price,
    :price_unit,
    :recording_sid,
    :sid,
    :status,
    :transcription_text,
    :uri
  ]

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(account_id, query \\ %{}), do: list(SignalWire.client(), account_id, query)

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, account_id, query) do 
    case Tesla.get!(client, build_url(@url, [account_id: account_id], query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, 
          as_struct(__MODULE__, Map.get(body, "transcriptions", [])), 
          paging(body)
        }

      response -> 
        {:error, response}
    end
  end

  @spec find(binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(account_id, sid), do: find(SignalWire.client(), account_id, sid)

  @spec find(Tesla.Client.t(), binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(client, account_id, sid) do
    case Tesla.get!(client, record_url(account_id, sid)) do
      %Tesla.Env{body: record, status: 200} -> 
        {:ok, as_struct(__MODULE__, record)}

      response -> 
        {:error, response}
    end
  end

  @spec delete(binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(account_id, sid), do: delete(SignalWire.client(), account_id, sid)

  @spec delete(Tesla.Client.t(), binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, account_id, sid) do 
    case Tesla.delete!(client, record_url(account_id, sid)) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end

  defp record_url(account_id, sid) do
    build_url(@url <> "/:sid", [account_id: account_id, sid: sid])
  end
end

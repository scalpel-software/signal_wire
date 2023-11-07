defmodule SignalWire.FaxMedia do 
  @moduledoc """
  Represents a Fax Media resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-all-fax-media)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/Faxes/:fax_sid/Media"

  defstruct [
    :account_sid,
    :content_type,
    :date_created,
    :date_updated,
    :fax_sid,
    :sid,
    :uri
  ]

  @spec list(binary, binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(account_id, sid, query \\ %{}), do: list(SignalWire.client(), account_id, sid, query)

  @spec list(Tesla.Client.t(), binary, binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, account_id, sid, query) do 
    case Tesla.get!(client, build_url(@url, [account_id: account_id, fax_sid: sid], query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, 
          as_struct(__MODULE__, Map.get(body, "media", [])),
          paging(body)
        }

      response -> 
        {:error, response}
    end
  end

  @spec find(binary, binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(account_id, fax_sid, media_sid) do
    find(SignalWire.client(), account_id, fax_sid, media_sid)
  end

  @spec find(Tesla.Client.t(), binary, binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(client, account_id, fax_sid, media_sid) do
    case Tesla.get!(client, record_url(account_id, fax_sid, media_sid)) do
      %Tesla.Env{body: record, status: 200} -> 
        {:ok, as_struct(__MODULE__, record)}

      response -> 
        {:error, response}
    end
  end

  @spec delete(binary, binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(account_id, fax_sid, media_sid) do
    delete(SignalWire.client(), account_id, fax_sid, media_sid)
  end

  @spec delete(Tesla.Client.t(), binary, binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, account_id, fax_sid, media_sid) do
    case Tesla.delete!(client, record_url(account_id, fax_sid, media_sid)) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end

  defp record_url(account_id, fax_sid, media_sid) do 
    build_url(@url <> "/:sid", [
      account_id: account_id, 
      fax_sid: fax_sid,
      sid: media_sid
    ])
  end
end

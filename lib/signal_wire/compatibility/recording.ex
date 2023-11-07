defmodule SignalWire.Recording do 
  @moduledoc """
  Represents a Recording resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-all-recordings)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/Recordings"
  @create_url "/api/laml/2010-04-01/Accounts/:account_id/Calls/:call_id/Recordings"

  defstruct [
    :account_sid,
    :api_version,
    :call_sid,
    :channels,
    :conference_sid,
    :date_created,
    :date_updated,
    :duration,
    :error_code,
    :price,
    :price_unit,
    :sid,
    :source,
    :start_time,
    :status,
    :uri
  ]

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(account_id, query \\ %{}), do: list(SignalWire.client(), account_id, query)

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, account_id, query) do 
    case Tesla.get!(client, build_url(@url, [account_id: account_id], query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, as_struct(__MODULE__, Map.get(body, "recordings", [])), paging(body)}

      response -> 
        {:error, response}
    end
  end

  @spec find(binary, binary, atom) :: SignalWire.success() | SignalWire.error()
  def find(account_id, sid, ext \\ :wav) do 
    find(SignalWire.client(), account_id, sid, ext)
  end

  @spec find(Tesla.Client.t(), binary, binary, atom) :: SignalWire.success() | SignalWire.error()
  def find(client, account_id, sid, ext) do
    case Tesla.get!(client, record_url(account_id, sid, ext)) do
      %Tesla.Env{body: record, status: 200} -> 
        {:ok, as_struct(__MODULE__, record)}

      response -> 
        {:error, response}
    end
  end

  @spec create(binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def create(account_id, call_sid, params) do 
    create(SignalWire.client(), account_id, call_sid, params)
  end

  @spec create(Tesla.Client.t(), binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def create(client, account_id, call_sid, params) do 
    case Tesla.post!(client, create_url(account_id, call_sid), params) do 
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec update(binary, binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(account_id, call_sid, sid, params) do 
    update(SignalWire.client(), account_id, call_sid, sid, params)
  end

  @spec update(Tesla.Client.t(), binary, binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, account_id, call_sid, sid, params) do
    case Tesla.post!(client, update_url(account_id, call_sid, sid), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  defp record_url(account_id, sid, :mp3) do
    build_url(@url <> "/:sid.mp3", [account_id: account_id, sid: sid])
  end

  defp record_url(account_id, sid, :json) do 
    build_url(@url <> "/:sid.json", [account_id: account_id, sid: sid]) 
  end

  defp record_url(account_id, sid, _ext) do
    build_url(@url <> "/:sid.wav", [account_id: account_id, sid: sid])
  end

  defp create_url(account_id, call_sid) do 
    build_url(@create_url, [account_id: account_id, call_id: call_sid])
  end

  defp update_url(account_id, call_id, sid) do 
    build_url(@create_url <> "/:sid", [
      account_id: account_id, 
      call_id: call_id,
      sid: sid
    ])
  end
end

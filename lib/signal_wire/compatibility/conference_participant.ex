defmodule SignalWire.ConferenceParticipant do 
  @moduledoc """
  Represents a Conference Participant resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-all-active-participants)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/Conferences/:conference_id/Participants"

  defstruct [
    :account_sid,
    :call_sid,
    :call_sid_to_coach,
    :coaching,
    :conference_sid,
    :date_created,
    :date_updated,
    :end_conference_on_exit,
    :muted,
    :hold,
    :start_conference_on_enter,
    :uri
  ]

  @spec list(binary, binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(account_id, conference_id, query \\ %{}) do 
    list(SignalWire.client(), account_id, conference_id, query)
  end

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, account_id, conference_id, query) do 
    case Tesla.get!(client, url_for(account_id, conference_id, query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, 
          as_struct(__MODULE__, Map.get(body, "participants", [])),
          paging(body)
        }

      response -> 
        {:error, response}
    end
  end

  @spec find(binary, binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(account_id, conference_id, sid) do 
    find(SignalWire.client(), account_id, conference_id, sid)
  end

  @spec find(Tesla.Client.t(), binary, binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(client, account_id, conference_id, sid) do 
    case Tesla.get!(client, record_url(account_id, conference_id, sid)) do
      %Tesla.Env{body: record, status: 200} -> 
        {:ok, as_struct(__MODULE__, record)}

      response -> 
        {:error, response}
    end
  end

  @spec update(binary, binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(account_id, conference_id, sid, params) do 
    update(SignalWire.client(), account_id, conference_id, sid, params)
  end

  @spec update(Tesla.Client.t(), binary, binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, account_id, conference_id, sid, params) do 
    case Tesla.post!(client, record_url(account_id, conference_id, sid), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec delete(binary, binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(account_id, conference_id, sid) do 
    delete(SignalWire.client(), account_id, conference_id, sid)
  end

  @spec delete(Tesla.Client.t(), binary, binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, account_id, conference_id, sid) do
    case Tesla.delete!(client, record_url(account_id, conference_id, sid)) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end

  defp url_for(account_id, conference_id, query) do 
    build_url(@url, [
      account_id: account_id, 
      conference_id: conference_id
    ], query)
  end

  defp record_url(account_id, conference_id, sid) do 
    build_url(@url <> "/:sid", [
      account_id: account_id, 
      conference_id: conference_id,
      sid: sid
    ])
  end
end

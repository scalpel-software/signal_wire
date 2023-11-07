defmodule SignalWire.QueueMember do 
  @moduledoc """
  Represents a Queue Member resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-all-queue-members)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/Queues/:queue_id/Members"

  defstruct [:call_sid, :date_enqueued, :position, :uri, :wait_time]

  @spec list(binary, binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(account_id, sid, query \\ %{}) do 
    list(SignalWire.client(), account_id, sid, query)
  end

  @spec list(Tesla.Client.t(), binary, binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, account_id, sid, query) do
    case Tesla.get!(client, build_url(@url, [account_id: account_id, queue_id: sid], query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, 
          as_struct(__MODULE__, Map.get(body, "queue_members", [])), 
          paging(body)
        }

      response -> 
        {:error, response}
    end
  end

  @spec find(binary, binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(account_id, queue_id, sid) do 
    find(SignalWire.client(), account_id, queue_id, sid)
  end

  @spec find(Tesla.Client.t(), binary, binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(client, account_id, queue_id, sid) do
    case Tesla.get!(client, record_url(account_id, queue_id, sid)) do
      %Tesla.Env{body: record, status: 200} -> 
        {:ok, as_struct(__MODULE__, record)}

      response -> 
        {:error, response}
    end
  end

  @spec update(binary, binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(account_id, queue_id, sid, params) do 
    update(SignalWire.client(), account_id, queue_id, sid, params)
  end

  @spec update(Tesla.Client.t(), binary, binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, account_id, queue_id, sid, params) do 
    case Tesla.post!(client, record_url(account_id, queue_id, sid), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  defp record_url(account_id, queue_id, sid) do 
    build_url(@url <> "/:sid", [
      account_id: account_id, 
      queue_id: queue_id,
      sid: sid
    ])
  end
end

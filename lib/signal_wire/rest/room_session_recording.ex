defmodule SignalWire.RoomSessionRecording do 
  @moduledoc """
  Represents a Room Session Recording resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-a-room-sessions-recordings)
  """

  import SignalWire.Utils

  @url "/api/video/room_sessions/:id/recordings"

  defstruct [
    :id,
    :room_session_id,
    :status,
    :started_at,
    :finished_at,
    :duration,
    :size_in_bytes,
    :format,
    :uri,
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
end
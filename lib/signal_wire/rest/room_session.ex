defmodule SignalWire.RoomSession do 
  @moduledoc """
  Represents a Room Recording resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-room-recordings)
  """

  import SignalWire.Utils

  @url "/api/video/room_sessions"

  defstruct [
    :id,
    :room_id,
    :name,
    :display_name,
    :join_from,
    :join_until,
    :remove_at,
    :remove_after_seconds_elapsed,
    :layout,
    :max_members,
    :fps,
    :quality,
    :start_time,
    :end_time,
    :duration,
    :status,
    :record_on_start,
    :enable_room_previews,
    :preview_url
  ]

  @spec list(map) :: SignalWire.success_list() | SignalWire.error()
  def list(query \\ %{}), do: list(SignalWire.client(), query)

  @spec list(Tesla.Client.t(), map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, query) do 
    case Tesla.get!(client, build_url(@url, [], query)) do 
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
    case Tesla.get!(client, build_url(@url <> "/:id", [id: id])) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
end

defmodule SignalWire.VideoConference do
  @moduledoc """
  Represents a Conference resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/create-a-video-conference)
  """

  
  import SignalWire.Utils

  @url "/api/video/conferences"

  defstruct [
    :id,
    :name,
    :display_name,
    :join_from,
    :join_until,
    :quality,
    :layout,
    :size,
    :record_on_start,
    :enable_room_previews,
    :enable_chat,
    :dark_primary,
    :dark_background,
    :dark_foreground,
    :dark_success,
    :dark_negative,
    :light_primary,
    :light_background,
    :light_foreground,
    :light_success,
    :light_negative,
    :created_at,
    :updated_at,
    :active_session
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

  @spec find(binary, map) :: SignalWire.success() | SignalWire.error()
  def find(id, query \\ %{}), do: find(SignalWire.client(), id, query)

  @spec find(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def find(client, id, query) do 
    case Tesla.get!(client, build_url(@url <> "/:id", [id: id], query)) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec create(map) :: SignalWire.success() | SignalWire.error()
  def create(params \\ %{}), do: create(SignalWire.client(), params)

  @spec create(Tesla.Client.t(), map) :: SignalWire.success() | SignalWire.error()
  def create(client, params) do 
    case Tesla.post!(client, @url, params) do 
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec update(binary, map) :: SignalWire.success() | SignalWire.error()
  def update(id, params \\ %{}), do: update(SignalWire.client(), id, params)

  @spec update(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, id, params) do 
    case Tesla.put!(client, build_url(@url <> "/:id", [id: id]), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec delete(binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(id), do: delete(SignalWire.client(), id)

  @spec delete(Tesla.Client.t(), binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, id) do 
    case Tesla.delete!(client, build_url(@url <> "/:id", [id: id])) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end
end

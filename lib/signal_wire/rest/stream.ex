defmodule SignalWire.Stream do 
  @moduledoc """
  Represents a Stream resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/find-a-stream-by-id)
  """

  import SignalWire.Utils

  @find_url "/api/video/streams/:id"

  defstruct [
    :id,
    :url,
    :stream_type,
    :width,
    :height,
    :fps,
    :created_at,
    :updated_at
  ]

  @spec find(binary) :: SignalWire.success() | SignalWire.error()
  def find(id), do: find(SignalWire.client(), id)

  @spec find(Tesla.Client.t(), binary) :: SignalWire.success() | SignalWire.error()
  def find(client, id) do 
    case Tesla.get!(client, build_url(@find_url, [id: id])) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec update(binary, map) :: SignalWire.success() | SignalWire.error()
  def update(id, params \\ %{}), do: update(SignalWire.client(), id, params)

  @spec update(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, id, params) do 
    case Tesla.put!(client, build_url(@find_url, [id: id]), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec delete(binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(id), do: delete(SignalWire.client(), id)

  @spec delete(Tesla.Client.t(), binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, id) do
    case Tesla.delete!(client, build_url(@find_url, [id: id])) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end
end

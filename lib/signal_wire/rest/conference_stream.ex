defmodule SignalWire.ConferenceStream do 
  @moduledoc """
  Represents a Conference Stream resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-streams-by-conference)
  """

  import SignalWire.Utils

  @url "/api/video/conferences/:id/streams"

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(id, query \\ %{}), do: list(SignalWire.client(), id, query)

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, id, query) do 
    case Tesla.get!(client, build_url(@url, [id: id], query)) do 
      %Tesla.Env{body: %{"data" => data, "links" => links}, status: 200} -> 
        {:ok, as_struct(SignalWire.Stream, data), rest_paging(links)}

      response -> 
        {:error, response}
    end
  end

  @spec create(binary, map) :: SignalWire.success() | SignalWire.error()
  def create(id, params \\ %{}), do: create(SignalWire.client(), id, params)

  @spec create(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def create(client, id, params) do 
    case Tesla.post!(client, build_url(@url, [id: id]), params) do 
      %Tesla.Env{body: body, status: 201} -> 
        {:ok, as_struct(SignalWire.Stream, body)}

      response -> {:error, response}
    end
  end
end

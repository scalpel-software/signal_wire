defmodule SignalWire.ConferenceToken do 
  @moduledoc """
  Represents a Conference Token resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-conference-tokens)
  """

  import SignalWire.Utils

  @url "/api/video/conferences/:conference_id/conference_tokens"
  @find_url "/api/video/conference_tokens/:id"

  defstruct [:id, :name, :token, :scopes]

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(conference_id, query \\ %{}) do 
    list(SignalWire.client(), conference_id, query)
  end

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, conference_id, query) do 
    case Tesla.get!(client, build_url(@url, [conference_id: conference_id], query)) do 
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
    case Tesla.get!(client, build_url(@find_url, [id: id])) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec reset(binary) :: SignalWire.success() | SignalWire.error()
  def reset(id), do: reset(SignalWire.client(), id)

  @spec reset(Tesla.Client.t(), binary) :: SignalWire.success() | SignalWire.error()
  def reset(client, id) do 
    case Tesla.get!(client, build_url(@find_url <> "/reset", [id: id])) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
end

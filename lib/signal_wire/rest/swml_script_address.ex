defmodule SignalWire.SwmlScriptAddress do 
  @moduledoc """
  Represents an Video Room Address resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-swml-script-addresses)
  """

  import SignalWire.Utils

  @url "/api/fabric/swml_scripts/:id/addresses"

  defstruct [
    :name,
    :display_name,
    :resource_id,
    :type,
    :cover_url,
    :preview_url,
    :channels
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
defmodule SignalWire.SwmlScript do 
  @moduledoc """
  Represents a SWML Script in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-swml-scripts)
  """

  import SignalWire.Utils

  @url "/api/fabric/swml_scripts"

  defstruct [
    :id,
    :project_id,
    :display_name,
    :type,
    :created_at,
    :updated_at,
    :swml_script
  ]

  @spec list(map) :: SignalWire.success_list() | SignalWire.error()
  def list(query \\ %{}), do: list(SignalWire.client(), query)

  @spec list(Tesla.Client.t(), map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, query) do 
    case Tesla.get!(client, build_url(@url, [], query)) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
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

  @spec create(map) :: SignalWire.success() | SignalWire.error()
  def create(params), do: create(SignalWire.client(), params)

  @spec create(Tesla.Client.t(), map) :: SignalWire.success() | SignalWire.error()
  def create(client, params) do 
    case Tesla.post!(client, build_url(@url, []), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
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

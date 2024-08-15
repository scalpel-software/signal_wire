defmodule SignalWire.PhoneNumber do
  @moduledoc """
  Represents a Phone Number resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-all-number-group-memberships)
  """

  import SignalWire.Utils

  @url "/api/relay/rest/phone_numbers"

  defstruct [
    :id,
    :number,
    :name,
    :call_handler,
    :call_receive_mode,
    :call_request_url,
    :call_request_method,
    :call_fallback_url,
    :call_fallback_method,
    :call_status_callback_url,
    :call_status_callback_method,
    :call_laml_application_id,
    :call_dialogflow_agent_id,
    :call_relay_context,
    :call_relay_connector_id,
    :call_sip_endpoint_id,
    :call_verto_resource,
    :call_video_room_id,
    :message_handler,
    :message_request_url,
    :message_request_method,
    :message_fallback_url,
    :message_fallback_method,
    :message_laml_application_id,
    :message_relay_context,
    :capabilities,
    :number_type,
    :e911_address_id,
    :created_at,
    :updated_at,
    :next_billed_at
  ]

  def search(query \\ %{}), do: search(SignalWire.client(), query)
  def search(client, query) do 
    case Tesla.get!(client, build_url(@url <> "/search", [], query)) do
      %Tesla.Env{body: %{"data" => data, "links" => links}, status: 200} -> 
        {:ok, as_struct(SignalWire.AvailablePhoneNumber, data), rest_paging(links)}

      response -> 
        {:error, response}
    end
  end

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

  @spec create(map) :: SignalWire.success() | SignalWire.error()
  def create(params \\ %{}), do: create(SignalWire.client(), params)

  @spec create(Tesla.Client.t(), map) :: SignalWire.success() | SignalWire.error()
  def create(client, params) do 
    case Tesla.post!(client, @url, params) do 
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

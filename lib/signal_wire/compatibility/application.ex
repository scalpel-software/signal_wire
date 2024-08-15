defmodule SignalWire.Application do 
  @moduledoc """
  Represents an Application resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-applications)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/Applications"

  defstruct [
    :account_sid,
    :api_version,
    :date_created,
    :date_updated,
    :friendly_name,
    :message_status_callback,
    :sid,
    :sms_fallback_method,
    :sms_fallback_url,
    :sms_method,
    :sms_status_callback,
    :sms_url,
    :status_callback,
    :uri,
    :voice_caller_id_lookup,
    :voice_fallback_method,
    :voice_fallback_url,
    :voice_method,
    :voice_url
  ]

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(id, query \\ %{}), do: list(SignalWire.client(), id, query)

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, id, query) do 
    case Tesla.get!(client, build_url(@url, [account_id: id], query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, as_struct(__MODULE__, Map.get(body, "applications", [])), paging(body)}

      response -> 
        {:error, response}
    end
  end

  @spec find(binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(account_id, app_id), do: find(SignalWire.client(), account_id, app_id)

  @spec find(Tesla.Client.t(), binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(client, account_id, app_id) do
    case Tesla.get!(client, record_url(account_id, app_id)) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec create(binary, map) :: SignalWire.success() | SignalWire.error()
  def create(id, params), do: create(SignalWire.client(), id, params)

  @spec create(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def create(client, id, params) do 
    case Tesla.post!(client, build_url(@url, [account_id: id]), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec update(binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(account_id, app_id, params) do 
    update(SignalWire.client(), account_id, app_id, params) 
  end

  @spec update(Tesla.Client.t(), binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, account_id, app_id, params) do 
    case Tesla.post!(client, record_url(account_id, app_id), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec delete(binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(account_id, app_id), do: delete(SignalWire.client(), account_id, app_id)

  @spec delete(Tesla.Client.t(), binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, account_id, app_id) do 
    case Tesla.delete!(client, record_url(account_id, app_id)) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end

  defp record_url(account_id, app_id) do 
    build_url(@url <> "/:application_id", [
      account_id: account_id, 
      application_id: app_id
    ])
  end
end

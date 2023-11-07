defmodule SignalWire.IncomingPhoneNumber do
  @moduledoc """
  Represents an Incoming Phone Number resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/list-all-incoming-phone-numbers)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/IncomingPhoneNumbers"

  defstruct [
    :account_sid,
    :address_requirements,
    :address_sid,
    :api_version,
    :beta,
    :capabilities,
    :date_created,
    :date_updated,
    :emergency_address_sid,
    :emergency_status,
    :friendly_name,
    :identity_sid,
    :origin,
    :phone_number,
    :sid,
    :sms_application_id,
    :sms_fallback_method,
    :sms_fallback_url,
    :sms_method,
    :sms_url,
    :status_callback,
    :status_callback_method,
    :trunk_sid,
    :uri,
    :voice_application_sid,
    :voice_caller_id_lookup,
    :voice_fallback_method,
    :voice_fallback_url,
    :voice_method,
    :voice_url
  ]

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(account_id, query \\ %{}), do: list(SignalWire.client(), account_id, query)

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, account_id, query) do 
    case Tesla.get!(client, build_url(@url, [account_id: account_id], query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, 
          as_struct(__MODULE__, Map.get(body, "incoming_phone_numbers", [])),
          paging(body)
        }

      response -> 
        {:error, response}
    end
  end

  @spec find(binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(account_id, sid), do: find(SignalWire.client(), account_id, sid)

  @spec find(Tesla.Client.t(), binary, binary) :: SignalWire.success() | SignalWire.error()
  def find(client, account_id, sid) do
    case Tesla.get!(client, record_url(account_id, sid)) do
      %Tesla.Env{body: record, status: 200} -> 
        {:ok, as_struct(__MODULE__, record)}

      response -> 
        {:error, response}
    end
  end

  @spec create(binary, map) :: SignalWire.success() | SignalWire.error()
  def create(account_id, params), do: create(SignalWire.client(), account_id, params)

  @spec create(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def create(client, account_id, params) do 
    case Tesla.post!(client, build_url(@url, [account_id: account_id]), params) do 
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec update(binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(account_id, sid, params) do 
    update(SignalWire.client(), account_id, sid, params)
  end

  @spec update(Tesla.Client.t(), binary, binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, account_id, sid, params) do 
    case Tesla.post!(client, record_url(account_id, sid), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec delete(binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(account_id, sid), do: delete(SignalWire.client(), account_id, sid)

  @spec delete(Tesla.Client.t(), binary, binary) :: SignalWire.success_delete() | SignalWire.error()
  def delete(client, account_id, sid) do 
    case Tesla.delete!(client, record_url(account_id, sid)) do 
      %Tesla.Env{status: 204} -> :ok
      response -> {:error, response}
    end
  end

  defp record_url(account_id, sid) do 
    build_url(@url <> "/:sid", [account_id: account_id, sid: sid])
  end
end

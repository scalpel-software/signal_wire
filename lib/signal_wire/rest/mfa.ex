defmodule SignalWire.MFA do 
  @moduledoc """
  Represents a Multi-Factor Authentication Token resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-logs-1)
  """

  import SignalWire.Utils
  
  @url "/api/relay/rest/mfa/:mfa_id/verify"



  defstruct [:id, :success, :to, :channel]

  @spec create(map, atom) :: SignalWire.success() | SignalWire.error()
  def create(params, method \\ :sms) do 
    create(SignalWire.client(), params, method)
  end

  @spec create(Tesla.Client.t(), map, atom) :: SignalWire.success() | SignalWire.error()
  def create(client, params, :sms) do
    case Tesla.post!(client, "/api/relay/rest/mfa/sms", params) do
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec create(Tesla.Client.t(), map, atom) :: SignalWire.success() | SignalWire.error()
  def create(client, params, :call) do
    case Tesla.post!(client, "/api/relay/rest/mfa/call", params) do
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec verify(binary, map) :: SignalWire.success() | SignalWire.error()
  def verify(mfa_request_id, params) do 
    verify(SignalWire.client(), mfa_request_id, params)
  end

  @spec verify(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def verify(client, mfa_request_id, params) do 
    case Tesla.post!(client, build_url(@url, [mfa_id: mfa_request_id]), params) do
      %Tesla.Env{body: body, status: 201} -> {:ok, body}
      response -> {:error, response}
    end
  end
end

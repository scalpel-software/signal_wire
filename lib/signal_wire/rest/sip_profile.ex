defmodule SignalWire.SipProfile do 
  @moduledoc """
  Represents a Sip Profile resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/retrieve-a-sip-profile)
  """

  import SignalWire.Utils

  @url "/api/relay/rest/sip_profile"

  defstruct [
    :domain,
    :domain_identifier,
    :default_codecs,
    :default_ciphers,
    :default_encryption,
    :default_send_as
  ]

  @spec find() :: SignalWire.success() | SignalWire.error()
  def find, do: find(SignalWire.client())

  @spec find(Tesla.Client.t()) :: SignalWire.success() | SignalWire.error()
  def find(client) do
    case Tesla.get!(client, @url) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec update(map) :: SignalWire.success() | SignalWire.error()
  def update(params \\ %{}), do: update(SignalWire.client(), params)

  @spec update(Tesla.Client.t(), map) :: SignalWire.success() | SignalWire.error()
  def update(client, params) do 
    case Tesla.put!(client, @url, params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
end

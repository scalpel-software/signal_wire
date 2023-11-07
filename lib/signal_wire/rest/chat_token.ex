defmodule SignalWire.ChatToken do 
  @moduledoc """
  Represents a Chat Token resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/generate-a-new-chat-token)
  """
  
  import SignalWire.Utils

  @url "/api/chat/tokens"

  defstruct [:type, :code, :message, :attribute, :url]

  @spec create(map) :: SignalWire.success() | SignalWire.error()
  def create(params \\ %{}), do: create(SignalWire.client(), params)

  @spec create(Tesla.Client.t(), map) :: SignalWire.success() | SignalWire.error()
  def create(client, params) do 
    case Tesla.post!(client, @url, params) do 
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
end

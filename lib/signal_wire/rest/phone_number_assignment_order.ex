defmodule SignalWire.PhoneNumberAssignmentOrder do 
  @moduledoc """
  Represents a Phone Number Assignment Order resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-all-phone-number-assignment-orders)
  """

  import SignalWire.Utils

  @url "/api/relay/rest/registry/beta/campaigns/:id/orders"

  defstruct [:id, :state, :processed_at, :created_at, :updated_at]

  @spec find(binary) :: SignalWire.success() | SignalWire.error()
  def find(id), do: find(SignalWire.client(), id)

  @spec find(Tesla.Client.t(), binary) :: SignalWire.success() | SignalWire.error()
  def find(client, id) do 
    case Tesla.get!(client, build_url(@url, [id: id])) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec create(binary, map) :: SignalWire.success() | SignalWire.error()
  def create(id, params \\ %{}), do: create(SignalWire.client(), id, params)

  @spec create(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def create(client, id, params) do 
    case Tesla.post!(client, build_url(@url, [id: id]), params) do 
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
end

defmodule SignalWire.PhoneNumberLookup do 
  @moduledoc """
  Represents a Phone Number Lookup resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/phone-number-lookup)
  """

  import SignalWire.Utils

  @url "/api/relay/rest/lookup/phone_number/:number"

  defstruct [
    :country_code_number,
    :national_number,
    :possible_number,
    :valid_number,
    :national_number_formatted,
    :international_number_formatted,
    :e164,
    :location,
    :country_code,
    :timezones,
    :number_type,
    :carrier,
    :cnam
  ]

  @spec find(binary, map) :: SignalWire.success() | SignalWire.error()
  def find(number, query), do: find(SignalWire.client(), number, query)

  @spec find(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def find(client, number, query) do
    case Tesla.get!(client, build_url(@url, [number: number], query)) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
end

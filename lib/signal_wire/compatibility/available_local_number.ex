defmodule SignalWire.AvailableLocalNumber do 
  @moduledoc """
  Represents an Available Local Number resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/compatibility-api/rest/search-for-available-phone-numbers-that-match-your-criteria)
  """

  import SignalWire.Utils

  @url "/api/laml/2010-04-01/Accounts/:account_id/AvailablePhoneNumbers/:country/Local"

  defstruct [
    :beta,
    :capabilities,
    :friendly_name,
    :iso_country,
    :lata,
    :latitude,
    :longitude,
    :phone_number,
    :postal_code,
    :rate_center,
    :region
  ]

  @spec list(binary, binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(account_id, country, query \\ %{}) do 
    list(SignalWire.client(), account_id, country, query)
  end

  @spec list(Tesla.Client.t(), binary, binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, account_id, country, query) do 
    case Tesla.get!(client, url_for(account_id, country, query)) do 
      %Tesla.Env{body: body, status: 200} -> 
        {:ok, 
          as_struct(__MODULE__, Map.get(body, "available_phone_numbers", [])),
          paging(body)
        }

      response -> 
        {:error, response}
    end
  end

  defp url_for(account_id, country, query) do
    build_url(@url, [account_id: account_id, country: country], query)
  end
end

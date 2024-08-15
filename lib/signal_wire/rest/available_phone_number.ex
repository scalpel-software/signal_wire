defmodule SignalWire.AvailablePhoneNumber do 
  defstruct [
    :e164,
    :country_code,
    :international_number_formatted,
    :national_number_formatted,
    :rate_center,
    :region,
    :capabilities
  ]
end
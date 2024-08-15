defmodule SignalWire.RequestValidator do 
  @moduledoc """
  Validates the authenticity of a SignalWire Request

  - [SignalWire docs](https://developer.signalwire.com/guides/webhook-security/)
  - [Reference Implementation](https://github.com/signalwire/compatibility-api-js)
  - [ExTwilio Implementation](https://github.com/danielberkompas/ex_twilio/blob/master/lib/ex_twilio/request_validator.ex)

  Code is based off of libe/webhooks/webhooks.js RestClient#validateRequest/5

  It looks like they are doing nearly the exact same thing as Twilio.
  The only two differences are handling lists when encoding params
  and handling check with and without the url's port
  """

  def valid?(url, params, signature, signing_key) do
    check_validity(url, params, signature, signing_key) ||
    check_validity(add_port(url), params, signature, signing_key) ||
    check_validity(remove_port(url), params, signature, signing_key)
  end

  def check_validity(url, params, signature, signing_key) do 
    url
    |> data_for(params)
    |> compute_hmac(signing_key)
    |> Base.encode64()
    |> String.trim()
    |> secure_compare(signature)
  end

  defp add_port(url) do
    case URI.parse(url) do
      uri = %URI{scheme: scheme} when scheme in ["http", "https"] -> 
        scheme <> ":" <>  URI.to_string(Map.put(uri, :scheme, nil))

      _other -> url
    end
  end

  defp remove_port(url) do 
    url |> URI.parse() |> Map.put(:port, nil) |> URI.to_string()
  end

  def data_for(url, params) do 
    params
    |> Map.keys()
    |> Enum.sort()
    |> Enum.reduce(url, fn key, acc -> 
        acc <> to_form_url_encoded_param(key, Map.get(params, key))
      end)
  end

  defp to_form_url_encoded_param(key, value) when is_list(value) do 
    Enum.reduce(value, "", fn item, acc -> 
      acc <> to_form_url_encoded_param(key, item) 
    end)
  end

  defp to_form_url_encoded_param(key, value), do: key <> value

  defp compute_hmac(data, key) do 
    :crypto.mac(:hmac, :sha, key, data)
  end

  # Implementation taken from Plug.Crypto
  # https://github.com/elixir-plug/plug_crypto/blob/v2.0.0/lib/plug/crypto.ex
  #
  # Compares the two binaries in constant-time to avoid timing attacks.
  # See: http://codahale.com/a-lesson-in-timing-attacks/
  defp secure_compare(left, right)  when is_binary(left) and is_binary(right) do
    byte_size(left) == byte_size(right) and :crypto.hash_equals(left, right)
  end
end

defmodule SignalWire.Config do 

  @moduledoc """
  Stores configuration variables used to communicate with Signal Wire's API.
  """

  @doc """
  Resolves the given key from the application's configuration 

  You can configure the application multiple different ways 

  by setting a value directly i.e.
  config :signal_wire, json_library: Jason

  by referencing an environment variable with a tuple
  config :signal_wire, auth_token: {:system, "SIGNAL_WIRE_TOKEN"}

  by using a function call 
  config :signal_wire, auth_token: fn -> System.get_env("SIGNAL_WIRE_TOKEN") end

  by applying a module with function and arguments
  config :signal_wire, auth_token: {MyApp.SecretStore, :signal_wire_token, []}

  or by referencing the value directly

  config :signal_wire, space: "my_app"
  """
  def resolve(key, default \\ nil)
  def resolve(key, default) when is_atom(key) do 
    Application.get_env(:signal_wire, key, default)
    |> expand_value()
  end

  def resolve(key, _) do 
    raise ArgumentError, message: "#{__MODULE__} expected key '#{key}' to be an atom"
  end

  defp expand_value({:system, env}), do: System.get_env(env)
  defp expand_value({module, function, args}) when is_atom(function) and is_list(args) do 
    apply(module, function, args)
  end

  defp expand_value(value) when is_function(value) do
    value.()
  end

  defp expand_value(value), do: value
end
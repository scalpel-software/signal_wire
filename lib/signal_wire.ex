defmodule SignalWire do
  @moduledoc """
  A relatively full featured API client for `SignalWire`.
  """

  @type success :: {:ok, map}
  @type success_list :: {:ok, [map], map}
  @type success_delete :: :ok
  @type error :: {:error, any}

  @doc """
  Handles building the Tesla client which gets passed into each 
  individual resource before making an HTTP request

  By default it will read from your local configuration,
  but you can create a per request client by providing a specific 
  project_id and token if you are managing multiple different subprojects
  within your application.
  """
  def client(adapter \\ nil) do 
    client(
      SignalWire.Config.resolve(:project),
      SignalWire.Config.resolve(:auth_token),
      adapter
    )
  end

  def client(project_id, token, adapter \\ nil) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, base_url()},
      {Tesla.Middleware.JSON, engine: json_engine(), engine_opts: json_opts()},
      {Tesla.Middleware.BasicAuth, %{username: project_id, password: token}}
    ], adapter_for(adapter))
  end

  defp base_url, do: base_url(SignalWire.Config.resolve(:space))
  defp base_url(space) when is_binary(space) do 
    "https://#{space}.signalwire.com"
  end

  defp base_url(_space) do
    raise """
    You must configure signal_wire with a space
    For example: config :signal_wire, space: "my_app"
    """
  end

  defp json_engine, do: SignalWire.Config.resolve(:json_library, Jason)
  defp json_opts, do: SignalWire.Config.resolve(:json_options, [])

  defp adapter_for(adapter) do 
    if is_nil(adapter) do
      SignalWire.Config.resolve(:adapter, Tesla.Adapter.Hackney)
    else
      adapter
    end
  end
end

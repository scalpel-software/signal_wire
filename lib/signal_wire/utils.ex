defmodule SignalWire.Utils do 
  @moduledoc false

  def as_struct(module, records) when is_list(records) do
    Enum.map(records, fn record -> as_struct(module, record) end)
  end

  def as_struct(module, record) do 
    struct(module, atomize_keys(record)) 
  end

  def build_url(url, params, query \\ [])
  def build_url(url, params, []) do 
    Enum.reduce(params, url, fn {key, value}, acc -> 
      String.replace(acc, ":#{key}", to_string(value))
    end)
  end

  def build_url(url, params, query) do 
    Enum.reduce(params, url, fn {key, value}, acc -> 
      String.replace(acc, ":#{key}", to_string(value))
    end) <> "?" <> to_query_string(query)
  end

  def paging(response) do 
    %{
      uri: Map.get(response, "uri"),
      first_query: from_query_string(Map.get(response, "first_page_uri")),
      next_query: from_query_string(Map.get(response, "next_page_uri")),
      previous_query: from_query_string(Map.get(response, "previous_page_uri")),
      page: Map.get(response, "page"),
      page_size: Map.get(response, "page_size")
    }
  end

  def rest_paging(links) do 
    %{
      uri: Map.get(links, "uri"),
      first_query: from_query_string(Map.get(links, "first")),
      next_query: from_query_string(Map.get(links, "next")),
      previous_query: from_query_string(Map.get(links, "previous")),
      page: Map.get(links, "page"),
      page_size: Map.get(links, "page_size")
    }
  end

  defp atomize_keys(nil), do: nil

  # Structs don't do enumerable and anyway the keys are already
  # atoms
  defp atomize_keys(struct = %{__struct__: _}) do
    struct
  end

  defp atomize_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {String.to_atom(k), atomize_keys(v)} end)
    |> Enum.into(%{})
  end

  # Walk the list and atomize the keys of
  # of any map members
  defp atomize_keys([head | rest]) do
    [atomize_keys(head) | atomize_keys(rest)]
  end

  defp atomize_keys(not_a_map) do
    not_a_map
  end

  defp to_query_string(list) do
    list
    |> Enum.flat_map(fn
      {key, value} when is_list(value) -> Enum.map(value, &{to_string(key), &1})
      {key, value} -> [{to_string(key), value}]
    end)
    |> URI.encode_query()
  end

  defp from_query_string(path) when is_binary(path) do 
    path
    |> URI.parse()
    |> Map.get(:query, "")
    |> URI.decode_query()
  end

  defp from_query_string(_), do: nil
end

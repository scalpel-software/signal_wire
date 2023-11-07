defmodule SignalWire.Brand do
  @moduledoc """
  Represents a Brand resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-all-brands)
  """

  import SignalWire.Utils

  @url "/api/relay/rest/registry/beta/brands"

  defstruct [
    :id,
    :state,
    :name,
    :company_name,
    :contact_email,
    :contact_phone,
    :ein_issuing_country,
    :legal_entity_type,
    :ein,
    :company_address,
    :company_vertical,
    :company_website,
    :csp_brand_reference,
    :csp_self_registered,
    :created_at,
    :updated_at
  ]

  @spec list(map) :: SignalWire.success_list() | SignalWire.error()
  def list(query \\ %{}), do: list(SignalWire.client(), query)

  @spec list(Tesla.Client.t(), map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, query) do 
    case Tesla.get!(client, build_url(@url, [], query)) do 
      %Tesla.Env{body: %{"data" => data, "links" => links}, status: 200} -> 
        {:ok, as_struct(__MODULE__, data), rest_paging(links)}

      response -> 
        {:error, response}
    end
  end

  @spec find(binary) :: SignalWire.success() | SignalWire.error()
  def find(id), do: find(SignalWire.client(), id)

  @spec find(Tesla.Client.t(), binary) :: SignalWire.success() | SignalWire.error()
  def find(client, id) do 
    case Tesla.get!(client, build_url(@url <> "/:id", [id: id])) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec create(map) :: SignalWire.success() | SignalWire.error()
  def create(params), do: create(SignalWire.client(), params) 

  @spec create(Tesla.Client.t(), map) :: SignalWire.success() | SignalWire.error()
  def create(client, params) do
    case Tesla.post!(client, @url, params) do 
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
end

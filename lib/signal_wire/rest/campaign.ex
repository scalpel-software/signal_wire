defmodule SignalWire.Campaign do 
  @moduledoc """
  Represents a Campaign resource in the Signal Wire API.

  - [Signal Wire docs](https://developer.signalwire.com/rest/list-all-campaigns)
  """

  import SignalWire.Utils

  @list_url "/api/relay/rest/registry/beta/brands/:brand_id/campaigns"
  @find_url "/api/relay/rest/registry/beta/campaigns/:id"

  defstruct [
    :id,
    :name,
    :state,
    :sms_use_case,
    :campaign_verify_token,
    :description,
    :sample1,
    :sample2,
    :sample3,
    :sample4,
    :sample5,
    :dynamic_templates,
    :message_flow,
    :opt_in_message,
    :opt_out_message,
    :help_message,
    :opt_in_keywords,
    :help_keywords,
    :number_pooling_required,
    :number_pooling_per_campaign,
    :direct_lending,
    :embedded_link,
    :embedded_phone,
    :age_gated_content,
    :lead_generation,
    :csp_campaign_reference,
    :created_at,
    :updated_at
  ]

  @spec list(binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(brand_id, query \\ %{}), do: list(SignalWire.client(), brand_id, query)

  @spec list(Tesla.Client.t(), binary, map) :: SignalWire.success_list() | SignalWire.error()
  def list(client, brand_id, query) do 
    case Tesla.get!(client, build_url(@list_url, [brand_id: brand_id], query)) do 
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
    case Tesla.get!(client, build_url(@find_url, [id: id])) do
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end

  @spec create(binary, map) :: SignalWire.success() | SignalWire.error()
  def create(brand_id, params \\ %{}), do: create(SignalWire.client(), brand_id, params)

  @spec create(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def create(client, brand_id, params) do 
    case Tesla.post!(client, build_url(@list_url, [brand_id: brand_id]), params) do 
      %Tesla.Env{body: body, status: 201} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
  
  @spec update(binary, map) :: SignalWire.success() | SignalWire.error()
  def update(id, params \\ %{}), do: update(SignalWire.client(), id, params)

  @spec update(Tesla.Client.t(), binary, map) :: SignalWire.success() | SignalWire.error()
  def update(client, id, params) do 
    case Tesla.put!(client, build_url(@find_url, [id: id]), params) do 
      %Tesla.Env{body: body, status: 200} -> {:ok, as_struct(__MODULE__, body)}
      response -> {:error, response}
    end
  end
end

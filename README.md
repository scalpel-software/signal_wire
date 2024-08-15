# SignalWire

Unofficial api client for https://www.signalwire.com/

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `signal_wire` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:signal_wire, "~> 0.1.1"}
  ]
end
```

## Configuration

You will need to set the following configuration variables in your
`config/config.exs` file:

```elixir
import Config

config :signal_wire, 
  space: {:system, "SIGNAL_WIRE_SPACE"},
  auth_token: {:system, "SIGNAL_WIRE_AUTH_TOKEN"},
  project: {:system, "SIGNAL_WIRE_PROJECT"},
  json_library: Jason # Optional (default)
  json_options: [] # Optional (default)
  adapter: Tesla.Adapter.Hackney # Optional (default)
```

## Usage

SignalWire comes with a module for each supported compatibility and rest API resource. 
For example, the "Call" resource is accessible through the `SignalWire.Call` module. Depending
on what the underlying API supports, a resource module may have the following
methods:

| Method      | Description                                                       |
|-------------|-------------------------------------------------------------------|
| **list**    | Eager load all of the resource items on all pages. Use with care! |
| **find**    | Find a resource given its SID.                                    |
| **create**  | Create a resource.                                                |
| **update**  | Update a resource.                                                |
| **delete**  | Destroy a resource.                                               |

There may be some custom methods on each module that correspond to non standard
actions that can be performed on the resource.

By default each function will build a SignalWire.client() based off of the default
configuration that you have provided. If you are running multiple tenants you can provide
your own custom clients to each of the functions for each subproject in SignalWire

```elixir
# Default Project
SignalWire.Call.create(project_id, %{
  ... Custom Call Params 
})

# Handling Multiple Tenants
SignalWire.Call.create(
  SignalWire.client(subproject_id, subproject_token),
  subproject_id,
  %{
    ... Custom Call Params 
  }
)
```

Each module will automatically build corresponding structs with any returned data
from the api. 

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/signal_wire](https://hexdocs.pm/signal_wire).


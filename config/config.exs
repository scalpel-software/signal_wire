import Config

config :tesla, disable_deprecated_builder_warning: true

import_config "#{config_env()}.exs"

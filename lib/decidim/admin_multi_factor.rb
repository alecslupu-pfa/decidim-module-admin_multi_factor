# frozen_string_literal: true

require "decidim/admin_multi_factor/admin"
require "decidim/admin_multi_factor/engine"
require "decidim/admin_multi_factor/admin_engine"
require "decidim/admin_multi_factor/overwrites"

module Decidim
  # This namespace holds the logic of the `AdminMultiFactor` component. This component
  # allows users to create admin_multi_factor in a participatory space.
  module AdminMultiFactor
    include ActiveSupport::Configurable

    autoload :PhoneNumberFormatter, "decidim/admin_multi_factor/phone_number_formatter"

    # Default configuration digits to generate the auth code.
    config_accessor :auth_code_length do
      4
    end

    config_accessor :code_ttl do
      5.minutes
    end
  end
end

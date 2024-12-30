# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class MultiFactorForm < Decidim::Form
        attribute :enable_multifactor, Boolean, default: false

        attribute :email, Boolean, default: false
        attribute :sms, Boolean, default: false
        attribute :webauthn, Boolean, default: false
      end
    end
  end
end

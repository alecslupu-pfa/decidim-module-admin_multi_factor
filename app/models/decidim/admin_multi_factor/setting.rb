# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    class Setting < ApplicationRecord
      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"

      def any?
        enable_multifactor? && [email?, sms?, webauthn?].any?
      end
    end
  end
end

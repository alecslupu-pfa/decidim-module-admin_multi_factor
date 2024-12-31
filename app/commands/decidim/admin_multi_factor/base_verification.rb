# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    class BaseVerification < Decidim::Command
      def initialize(user)
        @user = user
      end

      protected

      def verification_code
        @verification_code ||= generate_code
      end

      def generate_code
        code = SecureRandom.random_number(10**auth_code_length).to_s
        add_zeros(code)
      end

      def auth_code_length
        ::Decidim::AdminMultiFactor.auth_code_length
      end

      def add_zeros(code)
        return code if code.length == auth_code_length

        ("0" * (auth_code_length - code.length)) + code
      end

      def expires_at
        @expires_at ||= Time.zone.now + Decidim::AdminMultiFactor.code_ttl
      end
    end
  end
end

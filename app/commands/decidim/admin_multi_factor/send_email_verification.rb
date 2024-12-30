# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    class SendEmailVerification < Decidim::Command
      def initialize(user)
        @user = user
      end

      def call
        result = send_email_verification!

        if result
          broadcast(:ok, result, expires_at)
        else
          broadcast(:invalid)
        end
      end

      private

      attr_reader :user

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
        @expires_at ||= Time.now + Decidim::AdminMultiFactor.code_ttl
      end

      def send_email_verification!
        return false unless Decidim::AdminMultiFactor::VerificationCodeMailer
                              .verification_code(
                                email: user.email,
                                verification: verification_code,
                                organization: user.organization,
                                expires_at: expires_at
                              ).deliver_later

        verification_code
      end
    end
  end
end

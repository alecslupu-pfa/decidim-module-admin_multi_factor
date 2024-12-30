# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    class SendEmailVerification < BaseVerification

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

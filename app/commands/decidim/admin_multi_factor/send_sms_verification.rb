# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    class SendSmsVerification < BaseVerification

      def initialize(form, user)
        @form = form
        @user = user
      end

      def call
        result = send_sms_verification!

        if result
          broadcast(:ok, result, expires_at)
        else
          broadcast(:invalid)
        end
      end

      private

      def send_sms_verification!
        gateway.deliver_code

        gateway.code
      rescue StandardError => e
        @gateway_error_code = e.error_code

        false
      end

      def gateway
        @gateway ||=
          begin
            phone_number = phone_with_country_code(form.phone_country, form.phone_number)
            code = generate_code
            Decidim.config.sms_gateway_service.constantize.new(phone_number, code)
          end
      end

      def phone_with_country_code(country_code, phone_number)
        PhoneNumberFormatter.new(phone_number: phone_number, iso_country_code: country_code).format
      end

    end
  end
end

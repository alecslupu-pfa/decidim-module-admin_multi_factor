# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class UpdateAuthenticationSettings < Decidim::Command
        def initialize(admin_settings, form)
          @admin_settings = admin_settings
          @form = form
        end

        def call
          return broadcast(:invalid) if form.invalid?

          update_admin_login_settings
          broadcast(:ok)
        end

        private

        attr_reader :form

        def update_admin_login_settings
          Decidim.traceability.update!(
            @admin_settings,
            form.current_user,
            attributes
          )
        end

        def attributes
          {
            enable_multifactor: form.enable_multifactor,
            email: form.email,
            sms: form.sms,
            webauthn: form.webauthn
          }
        end
      end
    end
  end
end

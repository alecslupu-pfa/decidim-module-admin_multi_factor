# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class SmsStrategyController < ::Decidim::ApplicationController

        include FormFactory
        include AdminMultiFactorConcern

        helper Decidim::AdminMultiFactor::ApplicationHelper

        def sms
          @form = form(SmsCodeForm).instance
        end

        def verify
          raise "foobar"
        end

        def old_sms
          redirect_to_back && return unless admin_auth_settings.sms?

          SendSmsVerification.call(form, current_user) do
            on(:ok) do |result, expires_at|
              init_sessions!({ code: result, expires_at: expires_at, email: current_user.email, strategy: :email })
              flash[:notice] = I18n.t("success", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.sms", email: current_user.email)
              redirect_to action: "verify"
            end

            on(:invalid) do |_error_code|
              flash.now[:alert] = I18n.t("error", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.sms")
              render action: "elevate"
            end
          end
        end
      end
    end
  end
end

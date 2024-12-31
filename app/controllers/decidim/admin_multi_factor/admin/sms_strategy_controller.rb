# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class SmsStrategyController < ::Decidim::ApplicationController
        include FormFactory
        include AdminMultiFactorConcern

        helper Decidim::AdminMultiFactor::ApplicationHelper

        before_action :restrict_access, only: [:sms, :verify, :verify_sms_code]
        before_action :check_config, only: [:sms, :verify, :verify_sms_code]

        def sms
          @form = form(Decidim::AdminMultiFactor::SmsCodeForm).instance
        end

        def verify
          form = form(Decidim::AdminMultiFactor::SmsCodeForm).from_params(params)

          SendSmsVerification.call(form, current_user) do
            on(:ok) do |result, expires_at, phone_number|
              init_sessions!({ code: result, expires_at: expires_at, email: current_user.email, strategy: :sms })
              flash[:notice] = I18n.t("success", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.sms", phone_number: phone_number)
              redirect_to decidim_admin_multi_factor_admin.verify_sms_code_path
            end

            on(:invalid) do |_error_code|
              flash.now[:alert] = I18n.t("error", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.sms")
              redirect_to decidim_admin_multi_factor_admin.elevate_path
            end
          end
        end

        def verify_sms_code
          @form = form(::Decidim::AdminMultiFactor::VerificationCodeForm).instance
        end

        protected

        def check_config
          return if admin_auth_settings.sms?

          redirect_to_back and return
        end
      end
    end
  end
end

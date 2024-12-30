# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class EmailStrategyController < ::Decidim::ApplicationController
        include FormFactory
        include AdminMultiFactorConcern

        layout "decidim/application"

        before_action :authenticate_user!

        helper_method :current_user_impersonated?, :admin_auth_settings

        def email
          redirect_to_back && return unless admin_auth_settings.email?

          SendEmailVerification.call(current_user) do
            on(:ok) do |result, expires_at|
              init_sessions!({ code: result, expires_at: expires_at, email: current_user.email, strategy: :email })
              flash[:notice] = I18n.t("success", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.email", email: current_user.email)
              redirect_to decidim_admin_multi_factor_admin.verify_email_strategy_path
            end

            on(:invalid) do |_error_code|
              flash.now[:alert] = I18n.t("error", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.email")
              redirect_to decidim_admin_multi_factor_admin.elevate_path
            end
          end
        end

        def verify
          return redirect_to decidim_admin_multi_factor_admin.elevate_path if auth_session.blank?

          @form = form(::Decidim::AdminMultiFactor::VerificationCodeForm).instance
        end

      end
    end
  end
end

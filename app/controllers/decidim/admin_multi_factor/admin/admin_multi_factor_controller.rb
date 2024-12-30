# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class AdminMultiFactorController < ::Decidim::ApplicationController
        include FormFactory
        include AdminMultiFactorConcern

        layout "decidim/application"

        before_action :authenticate_user!

        helper_method :current_user_impersonated?, :admin_auth_settings

        def elevate
          redirect_to decidim.decidim_admin_path if auth_verified_session.present?

          respond_to do |format|
            format.html
          end
        end

        def sms
          redirect_to_back && return unless admin_auth_settings.sms?

          SendSmsVerification.call(current_user) do
            on(:ok) do |resylt, expires_at|
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

        def verify_submitted_code
          return redirect_to decidim_admin_multi_factor_admin.elevate_path if auth_session.blank?

          if auth_session[:code] == params[:verification_code][:verification]
            session[:auth_verified] = true
            init_sessions!
            flash[:notice] = I18n.t("success", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.verify")
            redirect_to decidim.decidim_admin_path
          else
            flash[:alert] = I18n.t("error", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.verify")
            redirect_to decidim_admin_multi_factor_admin.verify_email_strategy_path
          end
        end

      end
    end
  end
end

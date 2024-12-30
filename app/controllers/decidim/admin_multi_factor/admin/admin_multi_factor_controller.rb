# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class AdminMultiFactorController < ::Decidim::ApplicationController
        include FormFactory

        layout "decidim/application"

        before_action :authenticate_user!

        helper_method :current_user_impersonated?, :admin_auth_settings

        def elevate
          redirect_to decidim.decidim_admin_path if auth_verified_session.present?

          respond_to do |format|
            format.html
          end
        end

        def verify
          return redirect_to decidim_admin_multi_factor_admin.elevate_path if auth_session.blank?

          @form = form(::Decidim::AdminMultiFactor::VerificationCodeForm).instance
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
            redirect_to decidim_admin_multi_factor_admin.verify_strategy_path
          end
        end

        def email
          redirect_to_back && return unless admin_auth_settings.email?

          SendEmailVerification.call(current_user) do
            on(:ok) do |result, expires_at|
              init_sessions!({ code: result, expires_at: expires_at, email: current_user.email, strategy: :email })
              flash[:notice] = I18n.t("success", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.email", email: current_user.email)
              redirect_to action: "verify"
            end

            on(:invalid) do |_error_code|
              flash.now[:alert] = I18n.t("error", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.email")
              render action: "elevate"
            end
          end
        end

        protected

        def enforce_2fa; end

        def extended_rights_required; end

        private

        def admin_auth_settings
          @admin_auth_settings ||= Decidim::AdminMultiFactor::Setting.where(organization: current_organization).first_or_create
        end

        def current_user_impersonated?
          false
        end

        def init_sessions!(options = {})
          session[:auth_attempt] = options
        end

        def auth_session
          (session[:auth_attempt].presence || {}).with_indifferent_access
        end

        def auth_verified_session
          auth_session[:auth_verified]
        end
        #
        # def set_contact_info
        #   auth_session["email"] || PhoneNumberFormatter.new(
        #     phone_number: auth_session["phone"], iso_country_code: auth_session["country"]
        #   ).format
        # end
      end
    end
  end
end

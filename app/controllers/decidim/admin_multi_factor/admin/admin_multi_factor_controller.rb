# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class AdminMultiFactorController < ::Decidim::ApplicationController
        include FormFactory
        include AdminMultiFactorConcern

        def elevate
          redirect_to decidim.decidim_admin_path if auth_verified_session.present?

          respond_to do |format|
            format.html
          end
        end

        def verify_submitted_code
          return redirect_to decidim_admin_multi_factor_admin.elevate_path if auth_session.blank?

          if auth_session[:code] == params[:verification_code][:verification]
            init_sessions!
            session[:auth_verified] = true
            flash[:notice] = I18n.t("success", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.verify")
            redirect_to decidim.decidim_admin_path
          else
            flash[:alert] = I18n.t("error", scope: "decidim.admin_multi_factor.admin.admin_multi_factor.verify")
            redirect_to decidim_admin_multi_factor_admin.send(:"verify_#{auth_session[:strategy]}_strategy_path")
          end
        end
      end
    end
  end
end

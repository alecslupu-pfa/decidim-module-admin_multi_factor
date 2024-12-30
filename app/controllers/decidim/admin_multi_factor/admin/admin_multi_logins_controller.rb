# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      class AdminMultiLoginsController < ::Decidim::AdminMultiFactor::Admin::ApplicationController

        helper_method :admin_auth_settings

        def edit
          enforce_permission_to :update, :organization, organization: current_organization

          @form = form(Decidim::AdminMultiFactor::Admin::MultiFactorForm).from_model(admin_auth_settings)
        end


        def update
          enforce_permission_to :update, :organization, organization: current_organization

          @form = form(Decidim::AdminMultiFactor::Admin::MultiFactorForm).from_params(params)

          Decidim::AdminMultiFactor::Admin::UpdateAuthenticationSettings.call(admin_auth_settings, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("organization.update.success", scope: "decidim.admin")
              redirect_to action: :edit
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("organization.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        private
        def admin_auth_settings
          @admin_auth_settings ||= Decidim::AdminMultiFactor::Setting.where(organization: current_organization).first_or_create
        end
      end
    end
  end
end

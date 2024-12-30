# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Admin
      module AdminMultiFactorConcern
        extend ActiveSupport::Concern

        included do

          layout "decidim/application"

          before_action :authenticate_user!

          helper_method :current_user_impersonated?, :admin_auth_settings

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
        end
      end
    end
  end
end

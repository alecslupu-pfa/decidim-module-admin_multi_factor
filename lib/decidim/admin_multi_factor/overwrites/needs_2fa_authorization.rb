# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    module Overwrites
      module Needs2FAuthorization
        extend ActiveSupport::Concern
        include ::Devise::Controllers::SignInOut

        included do
          class ::Decidim::AdminMultiFactor::ExtendedRightsRequired < ::Decidim::ActionForbidden; end

          prepend_before_action :enforce_2fa

          rescue_from ::Decidim::AdminMultiFactor::ExtendedRightsRequired, with: :extended_rights_required

          def extended_rights_required
            # current_user.invalidate_all_sessions!
            redirect_to decidim_admin_multi_factor_admin.elevate_path
          end

          def enforce_2fa
            return unless admin_auth_settings.any?

            raise ::Decidim::AdminMultiFactor::ExtendedRightsRequired if session[:auth_verified].blank?
          end

          protected

          def admin_auth_settings
            @admin_auth_settings ||= Decidim::AdminMultiFactor::Setting.where(organization: current_organization).first_or_create
          end

        end
      end
    end
  end
end

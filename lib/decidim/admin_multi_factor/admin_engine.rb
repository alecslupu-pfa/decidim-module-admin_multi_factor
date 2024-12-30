# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    # This is the engine that runs on the public interface of `AdminMultiFactor`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::AdminMultiFactor::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        get "/elevate", to: "admin_multi_factor#elevate", as: :elevate
        get "/elevate/verify", to: "admin_multi_factor#verify", as: :verify_strategy
        post "/elevate/verify", to: "admin_multi_factor#verify_submitted_code", as: :verify_submitted_code
        post "/elevate/sms", to: "admin_multi_factor#sms", as: :select_sms_strategy
        post "/elevate/email", to: "admin_multi_factor#email", as: :select_email_strategy
        post "/elevate/webauthn", to: "admin_multi_factor#webauthn", as: :select_webauthn_strategy
        post "/elevate/:strategy", to: "admin_multi_factor#choose", as: :select_elevation_strategy

        scope "/organization" do
          resource :admin_multi_login, only: [:edit, :update]
        end
      end

      initializer "decidim_admin_multi_factor.mount_routes", before: "decidim_admin.mount_routes" do
        Decidim::Admin::Engine.routes.append do
          mount Decidim::AdminMultiFactor::AdminEngine => "/", as: :decidim_admin_multi_factor_admin
        end
      end


      initializer "decidim_admin_multi_factor.add_menu",  before: "decidim_admin.admin_settings_menu" do
        Decidim.menu :admin_settings_menu do |menu|
          menu.add_item :edit_authorization,
                        I18n.t("menu.admin_multifactor", scope: "decidim.decidim_admin_multi_factor"),
                        decidim_admin_multi_factor_admin.edit_admin_multi_login_path,
                        position: 1.1,
                        if: allowed_to?(:update, :organization, organization: current_organization),
                        active: is_active_link?(decidim_admin_multi_factor_admin.edit_admin_multi_login_path)
        end
      end

      def load_seed
        nil
      end

    end
  end
end

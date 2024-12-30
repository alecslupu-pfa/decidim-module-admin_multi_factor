# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module AdminMultiFactor
    # This is the engine that runs on the public interface of admin_multi_factor.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::AdminMultiFactor

      routes do
      end

      initializer "decidim_admin_multi_factor.mount_routes", before: "decidim_admin.mount_routes" do
        Decidim::Core::Engine.routes.append do
          mount Decidim::AdminMultiFactor::Engine => "/", as: :decidim_admin_multi_factor
        end
      end


      initializer "decidim_admin_multi_factor.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_admin_multi_factor.action_controller" do
        Rails.application.reloader.to_prepare do
          Decidim::Admin::ApplicationController.include Decidim::AdminMultiFactor::Overwrites::Needs2FAuthorization
        end
      end
    end
  end
end

# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  decidim_admin_multi_factor: "#{base_path}/app/packs/entrypoints/decidim_admin_multi_factor.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/admin_multi_factor/admin_multi_factor")

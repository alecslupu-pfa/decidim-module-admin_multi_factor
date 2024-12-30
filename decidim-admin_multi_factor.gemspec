# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/admin_multi_factor/version"

Gem::Specification.new do |s|
  s.version = Decidim::AdminMultiFactor.version
  s.authors = ["Alexandru Emil Lupu"]
  s.email = ["contact@alecslupu.ro"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-admin_multi_factor"
  s.required_ruby_version = "~> 3.0"

  s.name = "decidim-admin_multi_factor"
  s.summary = "A decidim admin_multi_factor module"
  s.description = "Allows to set elevated login rules for admin area."

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w(app/ config/ db/ lib/ LICENSE-AGPLv3.txt Rakefile README.md))
    end
  end
  
  s.add_dependency "countries", "~> 5.1", ">= 5.1.2"
  s.add_dependency "decidim-core", Decidim::AdminMultiFactor.version
end

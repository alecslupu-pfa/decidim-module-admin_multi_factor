# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "~> 0.27"
gem "decidim-core"

gem "graphql", "1.12.24"
gem "graphql-docs", "2.1.0"


gem "decidim-admin_multi_factor", path: "./"

gem "bootsnap", "~> 1.3"

group :development, :test do
  gem "decidim-dev"
end

group :development do
  gem "letter_opener_web", "~> 1.4"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.0"
end

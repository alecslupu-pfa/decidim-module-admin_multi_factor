# frozen_string_literal: true
namespace :decidim do
  namespace :admin_multi_factor do
    task :choose_target_plugins do
      ENV["FROM"] = "#{ENV.fetch("FROM", nil)},decidim_admin_multi_factor"
    end
  end
end


Rake::Task["decidim:choose_target_plugins"].enhance do
  Rake::Task["decidim:admin_multi_factor:choose_target_plugins"].invoke
end

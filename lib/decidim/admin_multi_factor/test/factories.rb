# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :admin_multi_factor_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :admin_multi_factor).i18n_name }
    manifest_name :admin_multi_factor
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end

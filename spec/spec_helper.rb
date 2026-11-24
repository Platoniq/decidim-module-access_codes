# frozen_string_literal: true

require "decidim/dev"

require "simplecov"
SimpleCov.start "rails"
if ENV["CI"]
  require "coveralls"
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path =
  File.expand_path(File.join(__dir__, "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|
  # Register the test workflow once: its engines get mounted in the routes, and
  # registering it again before every example draws the same route name twice
  # (Rails 8.1 raises "Invalid route name, already in use").
  config.before(:suite) do
    unless Decidim::Verifications.find_workflow_manifest(:ac_verification)
      Decidim::Verifications.register_workflow(:ac_verification) do |workflow|
        workflow.engine = Decidim::AccessCodes::Verification::Engine
        workflow.admin_engine = Decidim::AccessCodes::Verification::AdminEngine
      end
    end
  end
end

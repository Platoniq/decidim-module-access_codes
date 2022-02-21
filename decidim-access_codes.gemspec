# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/access_codes/version"

Gem::Specification.new do |s|
  s.version = Decidim::AccessCodes::VERSION
  s.authors = ["Vera Rojman"]
  s.email = ["vera@platoniq.net", "ivan@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/Platoniq/decidim-module-access_codes"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-access_codes"
  s.summary = "Allows admins to send access codes for user authorizations."
  s.description = "Access codes allow to verify users not yet registered on the platform."

  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  s.require_paths = ["lib"]

  s.add_dependency "decidim-admin", Decidim::AccessCodes::DECIDIM_VERSION
  s.add_dependency "decidim-core", Decidim::AccessCodes::DECIDIM_VERSION
  s.add_dependency "decidim-verifications", Decidim::AccessCodes::DECIDIM_VERSION

  s.add_development_dependency "decidim-dev", Decidim::AccessCodes::DECIDIM_VERSION
end

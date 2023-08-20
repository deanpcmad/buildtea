Buildkite.configure do |config|
  config.token = ENV["BUILDKITE_TOKEN"]
  config.org   = ENV["BUILDKITE_ORG"]
end

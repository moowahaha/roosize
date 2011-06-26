desc "Setup and install dependencies"
task :setup do
  
  NODE_DEPENDENCIES = %w{
    node-gd
    daemon
    mime
    jasmine-node
    coffee-script
  }

  sh "npm install #{NODE_DEPENDENCIES.join(' ')}"
end

namespace :test do
  desc "Run the spec tests"
  task :spec do
    sh "coffee test/spec.coffee"
  end

  desc "Run the integration tests"
  task :integration do
    sh "coffee test/integration.coffee"
  end

  desc "Run all tests"
  task all: [:spec, :integration]
end

# all defaults test every-thing
task test: ['test:all']
task default: [:setup, :test]

# frozen_string_literal: true

require 'minitest/test_task'

Minitest::TestTask.create(:test) do |t|
  t.libs << 'test'
  t.libs << '.'
  t.warning = false
  t.test_globs = ['test/**/*_test.rb']
end

task default: :test

task :worker do
  sh 'bin/worker'
end

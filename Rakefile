# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'infobar'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://flori.github.com/#{name}"
  summary     'Gem to display information about computations.'
  description 'This gem displays progress of computations and additional information to the terminal.'
  module_type :class
  test_dir    'spec'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', 'coverage', '.rvmrc',
    '.AppleDouble', 'tags', '.byebug_history', '.DS_Store', 'errors.lst'
  readme      'README.md'
  title       "#{name.camelize}"

  required_ruby_version '>= 2.3'
  dependency 'tins',           '~> 1.0', '>= 1.13.2'
  dependency 'term-ansicolor', '~> 1.4'
  dependency 'complex_config', '~> 0.10'
  development_dependency 'rake'
  development_dependency 'simplecov'
  development_dependency 'rspec'
end

task :default => :spec

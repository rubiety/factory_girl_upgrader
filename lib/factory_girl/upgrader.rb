require "rubygems"
require "factory_girl"
require "ruby_parser"
require "ruby_scribe"
require "ruby_transform"

require "factory_girl/upgrader/transformer"

Dir[File.join(File.dirname(__FILE__), "upgrader/transformers/**/*.rb")].each do |file|
  require file
end

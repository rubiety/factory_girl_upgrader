require "thor"
require "factory_girl/upgrader"

module FactoryGirl
  module Upgrader
    class Runner < Thor
      desc :cat, "Takes a single ruby file, parses it, and outputs the scribed version."
      def cat(path)
        sexp = RubyParser.new.parse(File.read(path))
        sexp = FactoryGirl::Upgrader::Transformer.new.transform(sexp)
        RubyScribe::Emitter.new.tap do |emitter|
          emitter.methods_without_parenthesis += ["factory"]
          puts emitter.emit(sexp)
        end
      end
      
      protected
    
      def expand_paths(paths = [])
        paths.map do |path|
          [path] + Dir[path + "**/*.rb"]
        end.flatten.uniq.reject {|f| File.directory?(f) }
      end
    end
  end
end
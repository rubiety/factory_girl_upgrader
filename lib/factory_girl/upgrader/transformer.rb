module FactoryGirl
  module Upgrader
    class Transformer < RubyTransform::Transformer
      def transform(e)
        super(transform_factories(e))
      end
      
      def transform_factories(e)
        if matches_define_factory?(e)
          transform_factory_definition(e)
        else
          e
        end
      end
      
      def matches_define_factory?(e)
        e.is_a?(Sexp) && e.kind == :iter &&  # We're in a block
          e.body.first.is_a?(Sexp) && e.body.first.kind == :call && # What's calling
            e.body.first.body.first == s(:const, :Factory) && e.body.first.body.second == :define &&  # Factory.define
            e.body.second.try(:kind) == :lasgn && # and we're passing a block variable for the factory
            e.body.third.try(:kind) == :block # and we have a block
      end
      
      def transform_factory_definition(e)
        factory_name = e.body.first.body.third.body.first.body.first  # Yeah... we really need an OO AST model.
        local_variable = e.body.second.body.first
        block = e.body.third
        
        s(:iter,
          s(:call, s(:const, :FactoryGirl), :define, s(:arglist)), nil,
          s(:iter,
            s(:call, nil, :factory, s(:arglist, s(:lit, factory_name.to_sym))), nil,
            transform_factory_definition_block(block, local_variable)
          )
        )
      end
      
      def transform_factory_definition_block(block, local_variable)
        Sexp.new(*([:block] + block.body.map {|e|
          case
          when matches_factory_association?(e, local_variable)
            transform_factory_association(e)
          when matches_factory_sequence?(e, local_variable)
            transform_factory_sequence(e)
          when matches_factory_attribute?(e, local_variable)
            transform_factory_attribute(e)
          else
            e
          end
        }))
      end
      
      # Factory Attributes:
      def matches_factory_attribute?(e, local_variable)
        e.is_a?(Sexp) && e.kind == :call && e.body.first.kind == :lvar && e.body.first.body.first == local_variable.to_sym
      end
      
      def transform_factory_attribute(e)
        e.dup.tap do |sexp|
          sexp[1] = nil
        end
      end
      
      # Factory Sequences:
      def matches_factory_sequence?(e, local_variable)
        e.is_a?(Sexp) && e.kind == :iter && matches_factory_attribute?(e.body.first, local_variable)
      end
      
      def transform_factory_sequence(e)
        e.dup.tap do |sexp|
          sexp[1] = transform_factory_attribute(sexp[1])
        end
      end
      
      # Factory Associations:
      def matches_factory_association?(e, local_variable)
        e.is_a?(Sexp) && e.kind == :call && e.body.first.kind == :lvar && e.body.first.body.first == local_variable.to_sym &&
          e.body.second == :association
      end
      
      def transform_factory_association(e)
        association_name = e.body.third.body.first.body.first
        
        s(:call, nil, association_name, s(:arglist))
      end
    end
  end
end
module Dun
  class Land
    attr_reader :data

    def self.inherited subclass
      return if Kernel.method_defined? subclass.name

      Kernel.class_eval %Q{
        def #{subclass.name} data = {}, &p
          #{subclass.name}.new(data).call &p
        end
      }

    rescue SyntaxError, TypeError

    end

    class MissingPatchedMethodError < StandardError
    end

    class << self

      def << data = {}
        new(data).call
      end

      def data_reader *attrs

        attrs.each do |attr|
          define_method attr do
            instance_variable_get("@#{attr}") ||\
            instance_variable_set("@#{attr}", data[attr.to_sym] || data[attr.to_s])
          end
        end

      end

      def set name, body
        if body.is_a? Proc
          define_method name, &body
        else
          define_method(name) {body}
        end
      end

      def patch *method_names
        method_names.each do |m|
          define_method m do
            msg = "Need implementing the patched method :#{m} in the subclass #{self.class}"
            raise MissingPatchedMethodError, msg
          end
        end
      end

    end

    def initialize data
      @data = data
    end

    def call
      return self
    end

    private

    def const_get name
      self.class.const_get name
    end

    def default attr, default_value
      instance_variable_set "@#{attr}", default_value if send(attr).nil?
    end

  end

end

module Dun
  class Activity
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

      def set attr, value
        define_method(attr) {value}
      end
      
    end
    
    def initialize data
      @data = data
    end
    
    def call
      'dun'
    end

    private

    def get_or_set attr, &p
      value = instance_variable_get "@#{attr}"
      return value if value
      value = p.call
      instance_variable_set "@#{attr}", value
    end

    def default attr, value
      instance_variable_set "@#{attr}", value if send(attr).nil?
    end

  end

end

module Dun
  class Activity
    attr_reader :data

    def self.inherited(subclass)
      return if Kernel.method_defined? subclass.name
      
      Kernel.class_eval %Q{
        def #{subclass.name}(data = {}, &p)
          #{subclass.name}.new(data).call(&p)
        end
      }

    rescue SyntaxError, TypeError
      
    end

    class << self

      def initializations
        @initializations ||= []
      end
      
      def <<(data = {})
        new(data).call
      end

      def data_reader *attrs
        
        attrs.each do |attr|
          define_method attr do
            instance_variable_get("@#{attr}") || \
            instance_variable_set("@#{attr}", data[attr.to_sym] || data[attr.to_s])
          end
        end
        
      end

      def data_default attr, value
        self.initializations << [:default, attr, value]
      end
      
      def set attr, value
        define_method "set_#{attr}" do
          instance_variable_set "@#{attr}", value
        end
        self.initializations << ["set_#{attr}"]
        
        attr_reader attr
      end
      
    end
    
    def initialize(data)
      @data = data
      self.class.initializations.each {|init|  execute_initialization init }
    end
    
    def call
      'dun'
    end

    private

    def execute_initialization(init)
      m, *args = init
      send m, *args
    end

    def get_or_set(attr, &p)
      value = instance_variable_get("@#{attr}")
      return value if value
      value = p.call
      instance_variable_set("@#{attr}", value)
    end

    def default(attr, value)
      instance_variable_set "@#{attr}", value if send(attr).nil?
    end

  end

end

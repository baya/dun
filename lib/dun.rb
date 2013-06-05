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
    
    def self.<<(data = {})
      new(data).call
    end

    def self.data_reader *attrs
      
      attrs.each do |attr|
        define_method attr do
          instance_variable_get("@#{attr}") || \
          instance_variable_set("@#{attr}", data[attr.to_sym] || data[attr.to_s])
        end
      end
      
    end
    
    def self.set name, value
      define_method(name) { value }
    end

    def initialize(data)
      @data = data
    end
    
    def call
      'dun'
    end

    private

    def get_or_set(name)
      value = instance_variable_get("@#{name}")
      return value if value
      value = yield
      instance_variable_set("@#{name}", value)
    end

  end

end

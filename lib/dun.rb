# -*- coding: utf-8 -*-
module Dun
  class Land
    attr_reader :data

    class MissingPatchedMethodError < StandardError
    end

    class TypeCheckError < StandardError
    end

    def self.inherited subclass
      subclass.args_with_type.merge!(self.args_with_type)
      return if Kernel.method_defined? subclass.name

      Kernel.class_eval %Q{
        def #{subclass.name} data = {}, &p
          #{subclass.name}.new(data).call &p
        end
      }

    rescue SyntaxError, TypeError

    end

    class << self

      def args_with_type
        @args_with_type ||= {}
      end

      def << data = {}
        new(data).call
      end

      def data_reader *args

        attrs = []

        args.each do |arg|
          if arg.is_a? Hash
            args_with_type.merge! arg
            attrs = attrs + arg.keys
          else
            args_with_type.delete arg
            attrs << arg
          end
        end
        attrs.uniq!

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

      if args_with_type.is_a? Hash
        type_check_list = []
        args_with_type.keys.each do |attr|
          value = send attr
          if args_with_type.is_a?(Hash)
            typeclass = args_with_type[attr]
            if not value.is_a? typeclass
              msg = "Need a #{typeclass}, but given a #{value.class}"
              type_check_list << [attr, msg]
            end
          end
        end

        if type_check_list.length > 0
          msg = type_check_list.map{|tc| ["#{tc[0]}, #{tc[1]}"]}.join("; ")
          raise TypeCheckError, msg
        end
      end

    end


    def call
      return self
    end

    private

    def args_with_type
      self.class.args_with_type
    end

    def const name
      self.class.const_get name
    end

    def default attr, default_value
      instance_variable_set "@#{attr}", default_value if send(attr).nil?
    end

  end
end

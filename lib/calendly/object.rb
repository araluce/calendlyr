require "ostruct"

module Calendly
  class Object < OpenStruct
    def initialize(attributes, client: nil)
      super to_ostruct(attributes.merge(client: client, uuid: extract_uuid(attributes)))
    end

    def to_ostruct(obj)
      klass = obj.class
      case klass
      when Hash
        OpenStruct.new(obj.map { |key, val| [key, to_ostruct(val)] }.to_h)
      when Array
        obj.map { |o| to_ostruct(o) }
      else # Assumed to be a primitive value
        obj
      end
    end

    def extract_uuid(attrs)
      attrs["uri"] ? get_slug(attrs["uri"]) : nil
    end

    def get_slug(path)
      path.split('/').last
    end

  end
end

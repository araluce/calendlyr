require "ostruct"

module Calendlyr
  class Object < OpenStruct
    def self.get_slug(path)
      path.split("/").last
    end

    def initialize(attributes)
      super(to_ostruct(attributes.merge(uuid: extract_uuid(attributes))))
    end

    def to_ostruct(obj)
      if obj.is_a?(Hash)
        OpenStruct.new(obj.map { |key, val| [key, to_ostruct(val)] }.to_h)
      elsif obj.is_a?(Array)
        obj.map { |o| to_ostruct(o) }
      else # Assumed to be a primitive value
        obj
      end
    end

    def extract_uuid(attrs)
      attrs["uri"] ? get_slug(attrs["uri"]) : nil
    end

    def get_slug(path)
      Calendlyr::Object.get_slug(path)
    end
  end
end

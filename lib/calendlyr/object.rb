module Calendlyr
  class Object
    def self.get_slug(path)
      path.split("/").last
    end

    private_class_method :get_slug

    def initialize(attributes = nil, add_uuid: true, **kwargs)
      attrs = (attributes || {}).merge(kwargs).dup
      if add_uuid && !attrs.key?(:uuid) && !attrs.key?("uuid")
        attrs = attrs.merge(uuid: extract_uuid(attrs))
      end

      @attributes = attrs.each_with_object({}) do |(key, value), hash|
        hash[key.to_s] = wrap(value)
      end
    end

    def method_missing(name, *args, &block)
      if args.empty? && block.nil?
        return @attributes[name.to_s] if @attributes.key?(name.to_s)

        return nil
      end

      super
    end

    def respond_to_missing?(name, include_private = false)
      @attributes.key?(name.to_s) || super
    end

    def to_h
      @attributes.each_with_object({}) do |(key, value), hash|
        hash[key.to_sym] = unwrap(value)
      end
    end

    def inspect
      attributes = @attributes.map do |key, value|
        "#{key}=#{value.inspect}"
      end.join(" ")
      "#<#{self.class} #{attributes}>"
    end

    def ==(other)
      other.is_a?(self.class) && to_h == other.to_h
    end

    def eql?(other)
      self == other
    end

    def hash
      to_h.hash
    end

    private

    def extract_uuid(attrs)
      uri = attrs["uri"] || attrs[:uri]
      uri ? get_slug(uri) : nil
    end

    protected

    def get_slug(path)
      self.class.send(:get_slug, path)
    end

    private

    def wrap(value)
      if value.is_a?(Hash)
        self.class.new(value, add_uuid: false)
      elsif value.is_a?(Array)
        value.map { |item| wrap(item) }
      else
        value
      end
    end

    def unwrap(value)
      if value.is_a?(self.class)
        value.to_h
      elsif value.is_a?(Array)
        value.map { |item| unwrap(item) }
      else
        value
      end
    end
  end
end

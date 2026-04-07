module Calendlyr
  class Webhooks::Payload < Object
    INVITEE_EVENTS = %w[
      invitee.created
      invitee.canceled
      invitee_no_show.created
      invitee_no_show.deleted
    ].freeze

    def initialize(attributes = nil, add_uuid: true, **kwargs)
      attrs = (attributes || {}).merge(kwargs)
      attrs = attrs.merge("payload" => payload_object(attrs))

      super(attrs, add_uuid: add_uuid)
    end

    private

    def payload_object(attrs)
      payload = attrs["payload"] || attrs[:payload]
      return payload unless payload.is_a?(Hash)

      return Webhooks::InviteePayload.new(payload, add_uuid: false) if INVITEE_EVENTS.include?(attrs["event"] || attrs[:event])

      payload
    end

    def wrap(value)
      return value unless value.is_a?(Hash)

      Calendlyr::Object.new(value, add_uuid: false)
    end
  end
end

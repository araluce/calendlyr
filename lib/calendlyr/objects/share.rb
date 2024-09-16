module Calendlyr
  class Share < Object
    def associated_scheduling_links
      scheduling_links.map do |scheduling_link|
        SchedulingLink.new(scheduling_link.to_h.merge(client: client))
      end
    end
  end
end

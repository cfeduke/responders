module Responders
  module HttpCache
    delegate :response, :to => :controller
    
    def to_format
      return if do_http_cache? && do_http_cache!
      super
    end
    
    protected
    def do_http_cache!
      response.last_modified ||= max_timestamp if max_timestamp
      head :not_modified if fresh = request.fresh?(response)
    end
    
    def max_timestamp
      @max_timestamp ||= resources.flatten.map do |resource|
        resource.updated_at.try(:utc) if resource.respond_to?(:updated_at)
      end.compact.max
    end
    
    def do_http_cache?
      get? && ActionController::Base.perform_caching
    end
  end
end
module GData
  module Client
    class Analytics < Base
      def initialize(options={})
        options[:clientlogin_service] ||= 'analytics'
        options[:authsub_scope] ||= 'https://www.google.com/analytics/feeds'
        super(options)
      end
    end
  end
end

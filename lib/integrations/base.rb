# Integration-specific libraries are required here

class Integration
  class Base
    # The list of report types. Currently each report type is matched to
    # a single widget type. This will change in the future.
    REPORT_TYPES = HashWithIndifferentAccess.new({ :report_type => :widget_type })

    # Sets any relevant ivars from the DataSource#config
    def initialize(data_source_config)
    end


    # Does the per-report data poll.
    # @param [Hash] options
    # @option options [Hash] :data_set_config ({}) the DataSet#config
    # @option options [Hash] :report_config ({}) the Report#config
    # @option options [Hash] :existing_data ({}) data that should be updated
    # @option options [Hash] :new_data data ({}) that should be added to the existing
    #   data (usually from a webhook call)
    # @return [Hash] data to save to the database
    def perform(options)
    end

    class DataSource

      # @return [Hash] The info required to build the form.
      # TODO: document these options
      def self.info
      end

      # Checks the configuration, performs any required modifications, and
      # returns it to be saved to the database. Called after 
      # @param [Hash] params the params returned from the form or authentication
      #   redirect
      # @return [Hash,false] the options to save to the database or `false` if
      #   the config is invalid
      def self.check_config(params)
      end

      # Generates a redirect URL for token-style authentication.
      # @param [Hash] config the params returned from the "Add Data Source" form
      # @param [String] url the URL the integration authentication service
      #   should redirect back to after successful authentication
      # @return [String] the URL to redirect the user to for authentication
      def self.redirect_url(config, url)
      end

    end


    class DataSet

      def self.info(data_source_config)
      end

      def self.check_config(config)
      end

    end

    class Report

      def self.info
      end

      def self.check_config(config)
      end

    end

  end
end

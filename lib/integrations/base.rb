# Integration-specific libraries are required here

class Integration
  class Base
    # The list of report types. Currently each report type is matched to
    # a single widget type. This will change in the future.
    REPORT_TYPES = HashWithIndifferentAccess.new({ :report_type => :widget_type })

    # Sets any relevant ivars from the DataSource#config
    def initialize(data_source_config)
    end


    # Compiles a report for the integration. Based ont he `:report_type` from
    # the report config, runs the methods required to generate a report. If
    # there is existing data, it should be intelligent and only poll for data
    # that is new or outdated. These steps should be performed in separate
    # methods. The reason it is setup like this is to prevent the polling system
    # from knowing about integration internals.
    # @param [Hash] options
    # @option options [Hash] :data_set_config ({}) the DataSet#config
    # @option options [Hash] :report_config ({}) the Report#config
    # @option options [Hash] :existing_data ({}) data that should be updated
    # @return [Hash] data to save to the database
    def perform(options)
    end

    # Later there should be a method here to update the data from a Push API
    # call.

    # Updates the report with new data received from a webhook.
    # @param [Hash] existing_data the data already in the database
    # @param [Hash] new_data the raw params from the webhook call
    # @return [Hash] the updated data to save to the database
    def webhook_update(existing_data, new_data)
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

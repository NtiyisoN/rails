module ActionController
  module Compatibility
    extend ActiveSupport::Concern

    # Temporary hax
    included do
      class << self
        delegate :default_charset=, :to => "ActionDispatch::Response"
      end

      self.protected_instance_variables = [
        :@_status, :@_headers, :@_params, :@_env, :@_response, :@_request,
        :@_view_runtime, :@_stream, :@_url_options, :@_action_has_layout
      ]
    end

    def render_to_body(options)
      super || " "
    end

    def _handle_method_missing
      method_missing(@_action_name.to_sym)
    end

    def method_for_action(action_name)
      super || (respond_to?(:method_missing) && "_handle_method_missing")
    end
  end
end

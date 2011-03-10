module Responders
  module Flash
    def to_html
      set_flash_message! unless get?
      super
    end
    
    def set_flash_message!
      status = has_errors? ? :alert : :notice
      return if controller.flash[status].present?
      
      namespace = controller.controller_path.gsub("/", ".")
      action = controller.action_name
      
      lookup = [namespace, action, status].join('.').to_sym
      default = ["actions", action, status].join('.').to_sym
      
      i18n_options = {
        :scope => :flash,
        :default => default,
        :resource_name => resource.class.model_name.human
      }
      
      message = I18n.t(lookup, i18n_options)
      controller.flash[status] = message if message.present?
    end
  end
end
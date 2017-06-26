module ApplicationHelper

  def is_active_controller(controller_name)
    params[:controller] == controller_name ? "active" : nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end

  def is_active_actions(action_names)
    action_names.include?(params[:action]) ? "active" : nil
  end

  def is_active_controller_and_action(controller_name, action_name)
    if params[:controller] == controller_name && params[:action] == action_name
      "active"
    else
      nil
    end
  end

  def is_any_unread_message?(user)
    user.chats.each{ |chat| chat.users.reject{ |t| t == current_user }.map{ |t| t.chat_messages}}
  end

  def has_unread_message?(user)
  end

  def br(str)
    html_escape(str).gsub(/\r\n|\r|\n/, "<br />").html_safe
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |flash_type, message|
      concat(
        content_tag(:div, message, class: "alert alert-dismissable #{bootstrap_class_for(flash_type)} fade in") do
          concat(
            content_tag(:button, class: "close", data: { dismiss: "alert" }) do
              concat content_tag(:span, "&times;".html_safe)
            end
          )
          concat message
        end
      )
    end
  end

end

module ActionView
  module Helpers
    module FormHelper
      def error_messages!(object_name, options = {})
        resource = self.instance_variable_get("@#{object_name}")
        return '' if !resource || resource.errors.empty?

        messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

        html = <<-HTML
          <div class="alert alert-danger">
            <ul>#{messages}</ul>
          </div>
        HTML

        html.html_safe
      end

      def error_css(object_name, method, options = {})
        resource = self.instance_variable_get("@#{object_name}")
        return '' if resource.errors.empty?

        resource.errors.include?(method) ? 'has-error' : ''
      end
    end

    class FormBuilder
      def error_messages!(options = {})
        @template.error_messages!(@object_name, options.merge(object: @object))
      end

      def error_css(method, options = {})
        @template.error_css(@object_name, method, options.merge(object: @object))
      end
    end
  end
end

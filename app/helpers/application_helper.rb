module ApplicationHelper
  def top_link_to(name, options = {}, html_options = {}, &block)
    css_class = current_page?(options) ? 'active' : nil
    content_tag 'li', nil, { class: css_class } do
      link_to(name, options, html_options, &block)
    end
  end

  def flash_messages
    return unless flash.any?

    items = []
    flash.each do |name, msg|
      msg   << content_tag(:a, raw('&times;'), :href => "#")
      items << content_tag(:li, raw(msg), :id => "flash-#{name}")
    end

    content_tag :ul, raw(items.join), :id => 'flash-messages'
  end
end

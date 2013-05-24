module ApplicationHelper
  def top_link_to(name, options = {}, html_options = {}, &block)
    css_class = current_page?(options) ? 'active' : nil
    content_tag 'li', nil, { class: css_class } do
      link_to(name, options, html_options, &block)
    end
  end
end

# encoding: utf-8

module RocketscienceHelper
  def doctype
    raw '<!DOCTYPE html>'
  end

  def with_header_and_footer(options = {}, &block)
    data = capture(&block)
    options = {
      :header => 'layouts/partials/header',
      :footer => 'layouts/partials/footer'
    }.merge(options)

    doctype + ie_html(:class => 'no-js', :lang => I18n.default_locale) do
      concat(render(:partial => options[:header]))
      concat(data)
      concat(render(:partial => options[:footer]))
    end
  end

  def date(date)
    return if date.nil?

    iso8601 = date.to_time.iso8601
    date = l(date, :format => :short)
    raw %Q(<time class="date" datetime="#{iso8601}" title="#{date}">#{date}</time>)
  end

  def utc_date(date)
    return if date.nil?

    iso8601 = date.to_time.iso8601
    date    = l(date)
    raw %Q(<time class="utc-date" datetime="#{iso8601}" title="#{date}">#{date}</time>)
  end

  attr_accessor :page_title

  def flash_messages
    return unless flash.any?

    items = []
    flash.each do |name, msg|
      msg   << content_tag(:a, raw('&times;'), :href => "#")
      items << content_tag(:li, raw(msg), :id => "flash-#{name}")
    end

    content_tag :ul, raw(items.join), :id => 'flash-messages'
  end

  def para(text)
    raw text.to_s.gsub! /([^\r\n]+)/, "<p>\\1</p>"
  end

  def short(text, length = 100)
    text = text.gsub /[\r\n]+/, ''
    strip_tags(truncate(text, :length => length))
  end

  # Set page title. Use this method in your views
  def title(title)
    @page_title = title
  end

  # This prints page title. Call this helper
  # inside title tag of your layout
  def page_title
    default_title = "Yet Another RussNet"

    if @page_title
      raw "#{@page_title} / #{default_title}"
    else
      default_title
    end
  end

  # Print heading (h1 by default) and set page title
  # at the same time. Use this method in your views
  def heading_with_title(heading, tag=:h1)
    title(heading)
    heading(heading, tag)
  end

  def heading(heading, tag=:h1)
    tag = :h1 if tag.nil?
    content_tag(tag, heading)
  end

  # Create a named haml tag to wrap IE conditional around a block
  # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither
  def ie_tag(name=:body, attrs={}, &block)
    attrs.symbolize_keys!
    result  = "<!--[if lt IE 7 ]> #{ tag(name, add_class('ie6', attrs), true) } <![endif]-->\n".html_safe
    result += "<!--[if IE 7 ]>    #{ tag(name, add_class('ie7', attrs), true) } <![endif]-->\n".html_safe
    result += "<!--[if IE 8 ]>    #{ tag(name, add_class('ie8', attrs), true) } <![endif]-->\n".html_safe
    result += "<!--[if IE 9 ]>    #{ tag(name, add_class('ie9', attrs), true) } <![endif]-->\n".html_safe
    result += "<!--[if (gte IE 9)|!(IE)]><!-->".html_safe

    result += content_tag name, attrs do
      "<!--<![endif]-->\n".html_safe + with_output_buffer(&block)
    end

    result
  end

  def ie_html(attrs={}, &block)
    ie_tag(:html, attrs, &block)
  end

  def ie_body(attrs={}, &block)
    ie_tag(:body, attrs, &block)
  end

private

  def add_class(name, attrs)
    classes = attrs[:class] || ''
    classes.strip!
    classes = ' ' + classes if !classes.blank?
    classes = name + classes
    attrs.merge(:class => classes)
  end

end
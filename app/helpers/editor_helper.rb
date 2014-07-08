# encoding: utf-8

module EditorHelper
  def domain_select
    options_for_select(Domain.all.map {|d| [d.name, d.id] }.prepend(['другое', nil]))
  end
end
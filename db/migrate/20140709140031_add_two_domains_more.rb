class AddTwoDomainsMore < ActiveRecord::Migration
  DOMAINS = %w(спорт_человек спорт_предмет)

  def up
    Domain.create(DOMAINS.map { |d| { author_id: 20, name: d } })
  end

  def down
    Domain.delete_all(name: DOMAINS)
  end
end

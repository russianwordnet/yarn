class AddTrashDomain < ActiveRecord::Migration
  def change
    Domain.create(author_id: 20, name: 'trash')
  end
end

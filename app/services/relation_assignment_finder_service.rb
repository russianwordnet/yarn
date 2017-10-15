class RelationAssignmentFinderService
  Assignment = Struct.new(:word1, :word2)

  def initialize(user)
    @user = user
  end

  def next_assignment
    relation = find_relation
    mark_relation_as_taken(relation)

    Assignment.new(relation.upper_id, relation.lower_id)
  end

  private

  def find_relation
    RawRelation
      .joins(:score)
      .where.not(id: RelationAssignment.select(:raw_relation_id).where(user_id: @user.id))
      .order("#{RawSubsumptionScore.table_name}.score desc")
      .first
  end

  def mark_relation_as_taken(relation)
    relation.relation_assignments.create(user: @user)
  end
end

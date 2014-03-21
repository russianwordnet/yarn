# encoding: utf-8

FactoryGirl.define do
  factory :word do
    word { Faker::Lorem.word }
    grammar { Faker::Lorem.characters(2) }
    # TODO: author and approver
  end
end

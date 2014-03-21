require 'spec_helper'

describe Word do
  it { should validate_presence_of(:word) }
  it { should belong_to(:author) }
  it { should belong_to(:approver) }
  it { should have_many(:old_words) }
  it { should have_many(:synset_words) }

  context 'history tracking' do
    let(:new_word) { FactoryGirl.build(:word) }
    subject { FactoryGirl.create(:word) }

    it 'should update from a new word' do
      subject.update_from(new_word)

      subject.revision.should == 2
      subject.old_words.size.should == 1

      subject.word.should == new_word.word
      subject.grammar.should == new_word.grammar
      subject.accents.should == new_word.accents
      subject.uris.should == new_word.uris
      subject.author_id.should == new_word.author_id
      subject.approver_id.should == new_word.approver_id
      subject.approved_at.should == new_word.approved_at
    end
  end
end

require 'rails_helper'

describe Question do
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :attachments }
  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should ensure_length_of(:title).is_at_least(5).is_at_most(255)}

end

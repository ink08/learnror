class Question < ActiveRecord::Base
  has_many :answers
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable
  belongs_to :user

	validates :title, :body, :user, presence: true
	validates_length_of		:title, in: 5..255

  accepts_nested_attributes_for :attachments
end

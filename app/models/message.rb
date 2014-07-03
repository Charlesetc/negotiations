# == Schema Information
#
# Table name: messages
#
#  id             :integer          not null, primary key
#  sender_id      :integer
#  receiver_id    :integer
#  negotiation_id :integer
#  content        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Message < ActiveRecord::Base
  attr_accessible :content, :negotiation_id, :receiver_id, :sender_id
	
	validates :content, presence: true
	validates :negotiation_id, presence: true
	validates :receiver_id, presence: true
	validates :sender_id, presence: true
	
	belongs_to :negotiation
	
	def sender
		User.find(self.sender_id)
	end
	
	def receiver
		User.find(self.receiver_id)
	end
	
	def supervisor?
		sender.admin or receiver.admin
	end
	
end

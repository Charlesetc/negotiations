# == Schema Information
#
# Table name: negotiations
#
#  id         :integer          not null, primary key
#  secure_key :string(255)
#  language   :string(255)
#  prompt     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Negotiation do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: agreements
#
#  id                :integer          not null, primary key
#  agree             :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer
#  agreement_boolean :boolean
#  price             :string(255)
#  description       :text
#

require 'spec_helper'

describe Agreement do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: scenarios
#
#  id          :integer          not null, primary key
#  general     :text
#  first_role  :text
#  second_role :text
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language    :string(255)
#

require 'spec_helper'

describe Scenario do
  pending "add some examples to (or delete) #{__FILE__}"
end

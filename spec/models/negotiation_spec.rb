# == Schema Information
#
# Table name: negotiations
#
#  id            :integer          not null, primary key
#  secure_key    :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  scenario_id   :integer
#  first_user_id :integer
#  start_time    :datetime
#  end_time      :datetime
#

require 'spec_helper'

describe Negotiation do
  pending "add some examples to (or delete) #{__FILE__}"
end

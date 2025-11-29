# == Schema Information
#
# Table name: api_logs
#
#  id         :integer          not null, primary key
#  method     :string
#  target_url :string
#  request    :jsonb
#  response   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ApiLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

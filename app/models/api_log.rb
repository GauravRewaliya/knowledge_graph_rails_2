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

class ApiLog < ApplicationRecord
  # REQUEST
  store :request, accessors: [
    :req_headers,
    :req_body,
    :req_method,
    :req_path,
    :req_query
  ], coder: JSON

  # RESPONSE
  store :response, accessors: [
    :res_status,
    :res_headers,
    :res_body,
    :res_time
  ], coder: JSON
end

# == Schema Information
#
# Table name: application_credentials
#
#  id                 :integer          not null, primary key
#  application_doc_id :integer          not null
#  title              :string
#  description        :text
#  credential_type    :string
#  rate_limits        :jsonb
#  settings           :jsonb
#  auth_data          :jsonb
#  is_active          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_application_credentials_on_application_doc_id  (application_doc_id)
#

class ApplicationCredential < ApplicationRecord
  belongs_to :application_doc
  belongs_to :application_credential
  belongs_to :user

  store :request_data, accessors: [ :url, :method, :headers, :body, :params ], coder: JSON
  store :response_data, accessors: [ :status, :headers, :body, :size ], coder: JSON

  # Duration is now stored in duration_ms, but we can keep the method for calculated duration
  def calculated_duration_ms
    return duration_ms if duration_ms.present?
    return nil unless requested_at && finished_at
    ((finished_at - requested_at) * 1000).round
  end

  before_save :calculate_duration_if_needed

  private

  def calculate_duration_if_needed
    if requested_at && finished_at && duration_ms.blank?
      self.duration_ms = ((finished_at - requested_at) * 1000).round
    end
  end
end

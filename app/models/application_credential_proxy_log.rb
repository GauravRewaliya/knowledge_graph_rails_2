# == Schema Information
#
# Table name: application_credential_proxy_logs
#
#  id                        :integer          not null, primary key
#  application_doc_id        :integer          not null
#  application_credential_id :integer          not null
#  user_id                   :integer          not null
#  request_data              :jsonb
#  response_data             :jsonb
#  requested_at              :datetime
#  finished_at               :datetime
#  credits_used              :decimal(, )
#  duration_ms               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  idx_on_application_credential_id_652e413c36                    (application_credential_id)
#  index_application_credential_proxy_logs_on_application_doc_id  (application_doc_id)
#  index_application_credential_proxy_logs_on_user_id             (user_id)
#

class ApplicationCredentialProxyLog < ApplicationRecord
  belongs_to :application_doc
  belongs_to :application_credential
  belongs_to :user

  store :request_data, accessors: [ :url, :method, :headers, :body, :params ], coder: JSON
  store :response_data, accessors: [ :status, :headers, :body, :size ], coder: JSON

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

# == Schema Information
#
# Table name: knowledge_queryfiers
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  project_id             :integer          not null
#  cypher_dynamic_query   :text
#  meta_data_swagger_docs :jsonb
#  tags                   :string
#  title                  :string
#  description            :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_knowledge_queryfiers_on_project_id  (project_id)
#  index_knowledge_queryfiers_on_user_id     (user_id)
#

class KnowledgeQueryfier < ApplicationRecord
  belongs_to :user, nullable: true
  belongs_to :project
end

# == Schema Information
#
# Table name: articles
#
#  id            :bigint           not null, primary key
#  archived      :boolean
#  content       :text
#  image         :string
#  reports_count :integer
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Article < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader

  after_update :archive_if_needed

  private

  def archive_if_needed
    if reports_count >= 3 && !archived
      update_column(:archived, true)
    end
  end
end

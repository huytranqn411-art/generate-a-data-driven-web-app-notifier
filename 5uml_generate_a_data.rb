# Data model for a data-driven web app notifier

require 'active_record'
require 'activerecord-import'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class App < ApplicationRecord
  has_many :notifications
  has_many :users
end

class User < ApplicationRecord
  has_many :notifications
  has_many :apps, through: :user_apps
end

class UserApp < ApplicationRecord
  belongs_to :user
  belongs_to :app
end

class Notification < ApplicationRecord
  belongs_to :app
  belongs_to :user

  scope :unread, -> { where(read: false) }
  scope :latest, -> { order(created_at: :desc) }

  validates :message, presence: true
end

class NotificationSetting < ApplicationRecord
  belongs_to :user
  belongs_to :app

  validates : frequency, presence: true
  validates : frequency, inclusion: { in: %w[daily weekly monthly] }
end
# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :access_tokens, # rubocop:disable Rails/InverseOf
           class_name:  'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent:   :delete_all
end

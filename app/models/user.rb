class User < ActiveRecord::Base
  devise :database_authenticatable, :omniauthable,
         :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password_hash, :password_salt
  attr_accessible :name, :provider, :uid, :token
  validate :name, length: { maximum: 100 }

  has_one :blob, :class_name => 'UserBlob'

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create!(name:     auth.extra.raw_info.login,
                          provider: auth.provider,
                          uid:      auth.uid,
                          email:    auth.info.email,
                          token:    auth.credentials.token,
                          password: Devise.friendly_token[0,20])
      UserBlob.create!(content: auth.to_json, user_id: user.id)
    end
    user
  end
end

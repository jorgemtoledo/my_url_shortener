class Link < ApplicationRecord

  UNIQUE_ID= 6
  validates :url, presence: true,  on: :create
  validates_format_of :url, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
  before_create :generate_slug_url
  before_create :sanitize

  def generate_slug_url
    slug = ([*('a'..'z'),*('0'..'9')]).sample(UNIQUE_ID).join
    # slug = "renovigi"
    old_url = Link.where(slug: slug).last
    if old_url.present?
      self.generate_slug_url
    else
      self.slug = slug
    end
  end

  def find_duplicate
    Link.find_by_sanitize_url(self.sanitize_url)
  end

  def new_url?
    find_duplicate.nil?
  end

  def sanitize
    self.url.strip!
    self.sanitize_url = self.url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
    self.sanitize_url = "http://#{self.sanitize_url}"
  end    
end

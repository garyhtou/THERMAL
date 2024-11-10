class Receipt < ApplicationRecord
  belongs_to :user

  belongs_to :provenance, polymorphic: true
  validates :provenance_type, inclusion: { in: [ Importer::GoogleDrive::File ].map(&:name) }

  validates_presence_of :name

  include Receipt::Analyze

  before_validation :set_user_from_provenance, on: :create
  before_validation :set_name_from_provenance, on: :create
  validate :same_user_as_provenance

  private

  def same_user_as_provenance
    errors.add(:user, "must be the same as provenance's user") unless user == provenance&.user
  end

  def set_user_from_provenance
    self.user = provenance.user
  end

  def set_name_from_provenance
    self.name ||= provenance&.try(:name)
  end
end

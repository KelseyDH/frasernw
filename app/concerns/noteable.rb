module Noteable
  extend ActiveSupport::Concern

  included do
    has_many :notes, as: :noteable
    accepts_nested_attributes_for :notes,
      reject_if: Proc.new {|attrs| !attrs["content"].present? }
  end

  def persisted_notes
    notes.select {|note| note.persisted? }
  end

  def new_notes
    notes.reject {|note| note.persisted? }
  end

  def build_new_note!(user = nil)
    notes.new(user: user)
  end
end

# Wraps an event that has happened to the target in order to provide a consistent interface for presentation

class HistoryNode
  include CustomPathHelper
  include Rails.application.routes.url_helpers
  include ReviewItemsHelper

  # {
  #   user: current_user,
  #   verb: :annotated,
  #   target: ReviewItem.last,
  #   datetime: DateTime.now,
  #   content: "This is a note"
  # }

  # add 'parent'?/ 'on'?

  # # # NAMED_FOREIGN_KEYS
  # # Shows changesets of foreign key columns using their human names.  So ScItem evidence_id would show: "x changed from 'B' to 'C'" rather than "x changed from '2' to '3'"
  # # To use, add the instance method `foreign_key_name` to the foreign_key attribute's model to specify what foreign key value to show (a), then reference add the attribute's foreign key / Model hash below (b):
  # # a) Evidence#foreign_key_name
  # # b) "evidence_id" => Evidence

  NAMED_FOREIGN_KEYS = {"evidence_id" => Evidence}

  def self.show_attribute(attribute, changeset_value)
    if NAMED_FOREIGN_KEYS.include?(attribute) && NAMED_FOREIGN_KEYS[attribute].safe_find(changeset_value).present?
      NAMED_FOREIGN_KEYS[attribute].safe_find(changeset_value).try(:foreign_key_name) # E.g. Evidence.find(2).foreign_key_name => "B"
    else
      changeset_value
    end
  end

  attr_reader :raw
  delegate :datetime, :changeset, :secret_editor, to: :raw

  def initialize(attrs)
    @raw = OpenStruct.new(attrs)
  end

  def user
    raw.user.name
  end

  def date
    raw.datetime.to_s(:date_ordinal)
  end

  def verb
    if archiving?
      "archived"
    elsif raw.verb == :migrated_annotation
      "'admin notes' field migrated"
    else
      raw.verb.to_s.gsub("_", " ")
    end
  end

  def review?
    secret_editor.present?
  end

  def target
    raw.target.numbered_label
  end

  def note
    "\"#{raw.note}\""
  end

  def has_note?
    raw.note.present?
  end

  def show_new_version_path?
    VersionsController::SUPPORTED_KLASSES_FOR_SHOW.include?(raw.target.class) && new_version_path.present?
  end

  def new_version_path
    duck_path(raw.new_version)
  end

  def target_is?(item)
    item == raw.target
  end

  def target_klass
    raw.target.class
  end

  def archiving?
    changeset.present? && changeset.keys[0] == "archived"
  end

  def target_link
    smart_duck_path(raw.target)
  end

  def annotation
    if raw.target.is_a?(ReviewItem) && raw.target.no_updates?
      " (No changes)"
    else
      ""
    end
  end
end

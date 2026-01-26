class Task < ApplicationRecord
   belongs_to :column
   belongs_to :user
   validates :title, presence: true
validates :position, numericality: { only_integer: true }, allow_nil: true
end

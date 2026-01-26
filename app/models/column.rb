class Column < ApplicationRecord
  belongs_to :board
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :position, numericality: true 
 before_validation :set_position, on: :create

  private

  def set_position
    self.position ||= board.columns.count
  end
end

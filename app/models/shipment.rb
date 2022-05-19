class Shipment < ApplicationRecord
  belongs_to :inventory
  validates :quantity, numericality: { greater_than: 0 }
  validate :check_sufficient_inventory
  before_save :update_inventory

  def value
    self.quantity * self.inventory.product.price
  end

  private

  def check_sufficient_inventory
    errors.add(:quantity, 'cannot be greater than available inventory') if self.quantity > self.inventory.quantity
  end

  def update_inventory
    shipment_amount = self.quantity
    inventory_amount = self.inventory.quantity

    self.inventory.update_attribute(:quantity, inventory_amount - shipment_amount)
  end
end

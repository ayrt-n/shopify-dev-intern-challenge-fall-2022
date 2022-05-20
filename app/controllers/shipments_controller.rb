class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all.order('updated_at DESC')
  end

  def show
    @shipment = Shipment.find(params[:id])
  end

  def new
    @product_options = Product.all.order('name').map { |p| [p.name, p.id] }
    @shipment = Shipment.new
  end

  def create
    @shipment = Shipment.new
    @shipment.shipment_items.build(shipment_params)

    if @shipment.save
      redirect_to shipments_path
    else
      @product_options = Product.all.order('name').map { |p| [p.name, p.id] }
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @shipment = Shipment.find(params[:id])
    @shipment.destroy

    redirect_to shipments_path, status: 303
  end

  private

  def shipment_params
    params.require(:shipment).permit(:product_id, :quantity)
  end
end

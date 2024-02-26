class Admin::ItEquipmentsController < ApplicationController
  before_action :authorize_admin
  before_action :set_it_equipment, only: %i[show edit update destroy]

  def index
    @equipment = ItEquipment.all
  end

  def show
  end

  def new
    @equipment = ItEquipment.new
  end

  def create
    @equipment = ItEquipment.new(it_equipment_params)
    if @equipment.save
      redirect_to admin_it_equipments_path, notice: "Техника успешно созданa."
    else
      render :new
    end
  end

  def edit
  end


  def update
    if @equipment.update(it_equipment_params)
      redirect_to admin_it_equipments_path, notice: "Техника успешно обновленa."
    else
      render :edit
    end
  end

  def destroy
    @equipment.destroy
    redirect_to admin_it_equipments_path, notice: "Техника успешно удаленa."
  end

  private

  def set_it_equipment
    @equipment = ItEquipment.find(params[:id])
  end

  def it_equipment_params
    params.require(:it_equipment).permit(:category, :make, :model, :description, :status, :user_id, :loaned_at)
  end
end

class Admin::HardwaresController < ApplicationController
  before_action :authorize_admin
  before_action :set_hardware, only: %i[show edit update destroy]

  def index
    @hardware = Hardware.all
  end

  def show
  end

  def new
    @hardware = Hardware.new
  end

  def create
    @hardware = Hardware.new(hardware_params)
    if @hardware.save
      redirect_to admin_hardwares_path, notice: "Техника успешно созданa."
    else
      render :new
    end
  end

  def edit
  end


  def update
    if @hardware.update(hardware_params)
      redirect_to admin_hardwares_path, notice: "Техника успешно обновленa."
    else
      render :edit
    end
  end

  def destroy
    @hardware.destroy
    redirect_to admin_hardwares_path, notice: "Техника успешно удаленa."
  end

  private

  def set_hardware
    @hardware = Hardware.find(params[:id])
  end

  def hardware_params
    params.require(:hardware).permit(:category_hard_id, :model, :series, :status, :user_id, :loaned_at)
  end
end

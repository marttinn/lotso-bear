class GenericFamiliesController < ApplicationController
  before_action :set_family, only: [:show, :destroy, :edit, :count_spares, :prices, :update, :assign_car_type]

  def new
    @generic_family = GenericFamily.new
    @generic_family.spare_likelihoods.build.build_generic_spare
  end

  def create
    @generic_family = GenericFamily.new(required_params)
    if @generic_family.save
      redirect_to generic_families_path
      unless @generic_family.generic_spares.blank?
        flash[:success] = "Familia: <strong>#{@generic_family.name}</strong>, con piezas: #{@generic_family.generic_spares.pluck(:name).join(', ').tr('[]', '')} creada con éxito".html_safe
      else
        flash[:success] = "Familia: <strong>#{@generic_family.name}</strong> creada con éxito".html_safe
      end
    else
      render 'new'
    end
  end

  def update
    @generic_car = GenericCar.find_by_id(params[:generic_family][:generic_car_id])
    respond_to do |format|
      if @generic_family.update(required_params)
        format.html { redirect_to assignation_generic_car_path( @generic_car.id ), notice: 'Guardado con éxito' }
      else
        format.html { render :edit }
      end
    end
  end


# <CREATE VARIANT>
  def variant
    @generic_family_father = GenericFamily.find_by_id(params[:id])
    @generic_car = GenericCar.find_by_id(params[:generic_car_id])
    @generic_family = GenericFamily.new
    @generic_family.father_id = @generic_family_father.id
    @generic_family.name ||= @generic_family_father.name
    @generic_family.code ||= @generic_family_father.code

    @generic_family_father.generic_spares.each do |generic_spare|
      pre_build = @generic_family.spare_likelihoods.build
      build = pre_build.build_generic_spare
      build.name = generic_spare.name
      build.code = generic_spare.code
    end
  end

  def create_variant
    @generic_car = GenericCar.find_by_id(params[:generic_car_id])
    generic_family_father = GenericFamily.find_by_id(params[:generic_family_father])

    variant_family = generic_family_father.clone_generic_family_with_generic_spares
    variant_family.original_id = generic_family_father.id
    variant_family.name ="#{variant_family.name}-#{params[:code]}" 
    variant_family.code ="#{variant_family.code}-#{params[:code]}"
    variant_family.years = params[:years]
    variant_family.variant_comment = params[:comment]
    variant_family.generic_spares.each do |generic_spare|
      generic_spare.code = "#{generic_spare.code}-#{params[:code]}"
    end
    @generic_car.generic_families << variant_family
    if @generic_car.save!
      flash[:success] = "Guardado con éxito"
      redirect_to edit_generic_family_path(variant_family,@generic_car)
    end
  end
# </CREATE VARIANT>


# <RELATE FAMILY TO CARTYPES>
  def assign_car_type
    @car_types = CarType.all
  end
# </RELATE FAMILY TO CARTYPES>
  def prices
  end

  def show
    @generic_car = GenericCar.find_by_id(params[:format])
  end

  def index
    @generic_families = GenericFamily.all.where(father_id: nil)
  end

  def edit
    @generic_car = GenericCar.find_by_id(params[:generic_car_id])
  end

  def destroy
    @generic_family.destroy
    flash[:danger] = "#{@generic_family.name} borrada con éxito"
    redirect_to action: 'index'
  end

  def assigned
    @generic_families_assigned = GenericFamily.assigned_families
    @generic_families_not = GenericFamily.not_assigned_families
    @car_types = CarType.all
  end

  def assign
    family = params[:family_ids]
    unless family.blank?
      family.each do | f |
        family_id = f.split(',')[0].to_i
        type_id = f.split(',')[1].to_i
        type_likelihood = TypeLikelihood.new(generic_family_id: family_id, car_type_id:type_id)
        if type_likelihood.save
          GenericFamily.add_to_corresponding_cars(type_likelihood)
        end
      end
      flash[:success] = "Actualizado con éxito"
    end
    redirect_to assigned_generic_families_path
  end



  private
    def required_params
      params.require(:generic_family).permit(:generic_car_id,:code,:name, :years, {:types => []},{:family_ids => []} ,spare_likelihoods_attributes:[:id, :generic_family_id, :generic_spare_id, :_destroy, generic_spare_attributes:[:id, :name,:code, :_destroy]])
    end

    def set_family
      @generic_family = GenericFamily.find_by_id(params[:id])
    end

end

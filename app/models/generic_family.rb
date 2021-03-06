# -*- encoding : utf-8 -*-
class GenericFamily < ActiveRecord::Base

  has_many :childs, class_name: 'GenericFamily', foreign_key: 'father_id'
  belongs_to :father, class_name: 'GenericFamily'

  has_many :variants, class_name: 'GenericFamily', foreign_key: 'original_id'
  belongs_to :original, class_name: 'GenericFamily'

  has_many :spare_likelihoods, dependent: :destroy
  has_many :generic_spares, -> { order 'code' }, through: :spare_likelihoods, dependent: :destroy

  has_many :stock_families, dependent: :destroy

  has_many :type_likelihoods, dependent: :destroy
  has_many :car_types, through: :type_likelihoods

  has_many :family_likelihoods, dependent: :destroy
  has_many :generic_cars, through: :family_likelihoods

  has_many :suppliers, through: :supplier_codes
  has_many :supplier_codes, dependent: :destroy

  has_many :generic_family_images

  accepts_nested_attributes_for :generic_spares
  accepts_nested_attributes_for :spare_likelihoods, allow_destroy: true

  validates :name, presence: :true
  validates :code, presence: :true
  attr_accessor :generic_car_id

  after_save :delete_empty_spare_likelihoods
              
  def delete_empty_spare_likelihoods
    spare_likelihoods.each do |spare_likelihood|
      if spare_likelihood.generic_family_id.blank? or spare_likelihood.generic_spare_id.blank?
        spare_likelihood.delete
      end
    end
  end
# Clones of a generic_families to all the generic_cars that have the same car_type as the parameter. 
# Params:
# +type_likelihood+:: +TypeLikelihood+ object from which to extract the generic family and car_type
  def self.add_to_corresponding_cars (type_likelihood)
    ActiveRecord::Base.transaction do
      # Select all the cars with the car_type of the type_likelihood_parameter
      generic_cars = GenericCar.where(car_type_id:type_likelihood.car_type_id)
      # Selects the family  from the type_likelihood parameter
      family = type_likelihood.generic_family
      # Clones a generic_family. Relates the clone to each generic_car
      generic_cars.each do |generic_car|
        # Clone the family with generic spares
        clone = family.clone_generic_family_with_generic_spares
        clone.years = generic_car.formatted_year
        unless clone.blank?
          # Relates the clone to a generic_car
          generic_car.generic_families << clone
        end
      end
    end
  end

# Searches generic_families that haven´t been related to the given generic_car 
# Params:
# +spares_info+:: +Array+ containing hashes with spare info (a hash has an id +Integer+ from a generic_spare, +String+ supplier_code, +String+ color), 
# +car_id+:: +Integer+ object Integer of a GenericCar (The one that was specified in a order)
# Returns A StockFamily
  def generate_stock_family_with_stock_spares (spares_info, car_id)
    #  New empty StockFamily
    stockFam = StockFamily.new
    # Assign the original id to the clone (Its father)
    stockFam.generic_family_id = self.id
    # Assign the id of the given GenericCar
    stockFam.car_order_id = car_id
  # Check that the spare info isn´t empty  
    unless spares_info.blank?
      # Loop each hash
      spares_info.each do |spare_tuple|
        # Check the hash isn´t empty
        unless spare_tuple[:id].blank?
          # New empty StockSpare
          spare = StockSpare.new
          # Relate spare to a Generic Spare
          spare.generic_spare_id = spare_tuple[:id]
          # Add supplier code (String)
          spare.supplier_code = spare_tuple[:supplier_code]
          # Update Status 
          spare.status = "Almacen"
          # Add the new StockSpare to the StockFamily
          stockFam.stock_spares << spare
        end
      end
    end
    # Return a StockFamily
    stockFam
  end

# Interpolates the name and code of self
# Returns: a string
  def name_with_code
    "#{self.name}, #{self.code}"
  end

# Clones a GenericFamily including the GenericSpares it contains. 
# Returns A GenericFamily 
  def clone_generic_family_with_generic_spares
    clone = self.dup
    self.generic_spares.each do | spare|
      clone_spare = spare.dup
      clone_spare.father_id = spare.id
      clone.generic_spares << clone_spare
    end
    clone.father = self
    clone
  end

    def get_supplier_code(supplier)
    supplier_code = SupplierCode.where(generic_family_id: self.id, supplier_id: supplier.id)
    unless supplier_code.blank?
      supplier_code.first.code
    end
  end

  def get_price(supplier)
    supplier_code = SupplierCode.where(generic_family_id: self.id, supplier_id: supplier.id)
    supplier_code.first.price
  end

  def has_supplier_code?(supplier)
    supplier_code = SupplierCode.where(generic_family_id: self.id, supplier_id: supplier.id)
    if supplier_code.blank?
      return false
    else
      return true
    end
  end


  # // QUERIES //
# Searches all generic families that have not been related to a Typelikehood (Families that don´t have a car_type)
# Returns Array of GenericFamily
  def self.not_assigned_families
    where.not(:id  => TypeLikelihood.select(:generic_family_id)).where(father_id: nil)
  end

# Searches all generic families that have been related to a Typelikehood (Families that have a car_type)
# Returns Array of GenericFamily
  def self.assigned_families
    where(:id  => TypeLikelihood.select(:generic_family_id) ).where(father_id: nil)
  end

# Searches generic_families that haven´t been related to the given generic_car 
# Params:
# +generic_car+:: +GenericCar+ object
# Returns Array of GenericFamily
  def self.other_families(generic_car)
    # If the generic car doesn´t have any generic families Return all the GenericFamilies
    if generic_car.generic_families.empty?
      all
    else
      # Query that fidns all families that are not related to the generic_car
      where('id not in (?)', generic_car.generic_families.pluck(:id).concat(generic_car.generic_families.pluck(:father_id)).compact).where(father_id: nil)
    end
  end

# Searches all generic families that match by name, code or generic_car model
# Params:
# +generic_car+:: +String+ model of a generic_car
# +generic_family+:: +String+ name of a generic_family
# Returns Array of GenericFamilys
  def self.search(generic_family, generic_car)
    if !generic_family.blank? && !generic_car.blank?
      generic_families = GenericFamily.joins(generic_cars: :model_acronym).where("lower(name) LIKE ? OR lower(code) like ?","%#{generic_family.downcase}%", "%#{generic_family.downcase}%").where( model_acronyms: {model: generic_car.upcase})
    elsif generic_family.blank?
      generic_families = GenericFamily.joins(generic_cars: :model_acronym).where( model_acronyms: {model: generic_car.upcase})
    else
      generic_families = GenericFamily.where("lower(name) LIKE ? OR lower(code) like ?","%#{generic_family.downcase}%", "%#{generic_family.downcase}%")
    end
    generic_families
  end

# Searches all generic families that are not related to the supplier
# Params:
# +supplier+:: +Supplier+ object
# Returns Array of GenericFamilys
  def self.without_supplier_code(supplier)
    # joins(:supplier_codes).where( supplier_codes: {supplier_id: supplier.id})
    where.not(father_id: nil).limit 500
  end
end
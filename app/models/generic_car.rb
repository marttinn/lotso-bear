class GenericCar < ActiveRecord::Base

  # //Associations//
  has_many :stock_cars
  has_many :generic_fittables

  belongs_to :brand

  belongs_to :model_acronym, inverse_of: :generic_cars

  accepts_nested_attributes_for :model_acronym, reject_if: proc{|attributes| attributes[:model].blank? }
  # validates_presence_of :model_acronym



  has_many :generic_car_generations
  has_many :generations, through: :generic_car_generations

  has_many :car_likelihoods
  has_many :car_types, through: :car_likelihoods

  has_many :generic_car_images, dependent: :destroy
  accepts_nested_attributes_for :generic_car_images



  # //Validations//
  validates :brand_id, presence: true
  validates :years, presence: true
  validates :years, presence: true
  validates :number_of_generation, presence: true
  validates :model_acronym, presence: true
  before_save :generation_split

  def code
    "#{brand.acronym}-#{number_of_generation}-#{model_acronym.initials}"
  end

  def years_split
    if self.years.length == 4
      self.first_generation_year = self.years
      self.last_generation_year = Date.today.year
    else
      self.first_generation_year = self.years.split('-')[0]
      self.last_generation_year = years.split('-')[1]
    end
  end

  # //Queries//
  def self.search(query)
    where("model like ? OR brand like ? OR year like ?", "%#{query}%", "%#{query}%", "%#{query}%")
  end

  def self.gen_continues_search
    where(gen_continues: true)
  end

  # //Functions//
  private
  def retrieve_code
  end


  def generation_split
    years_split
    for i in self.first_generation_year.to_i..self.last_generation_year.to_i
      @record = Generation.find_by_year(i)
      @generation = GenericCarGeneration.new(generic_car_id:self.id, generation_id: @record.id)
      @generation.save
    end
  end

  def generation_order
    if last_generation_year < first_generation_year
      errors.add(:last_generation_year, "Ultimo año de generación no puede ser menor al primer año de generación")
    end
  end

end

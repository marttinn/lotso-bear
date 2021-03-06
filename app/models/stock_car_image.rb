# -*- encoding : utf-8 -*-
class StockCarImage < ActiveRecord::Base
  belongs_to :stock_car, dependent: :destroy

  has_attached_file :image, :styles => { :medium => "500x500>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end

class Service < ApplicationRecord
  is_impressionable :counter_cache => true, :column_name => :impressions_count

  has_many :alternative_services, foreign_key: :service_id, class_name: 'Alternative'
  has_many :alternatives, through: :alternative_services

  # Pantherscore sources
  has_one :privacymonitor
  has_many :privacyscores
  has_many :pribots
  has_many :service_tosdrs
  has_many :tosdrs, through: :service_tosdrs
  has_one :service_hibp
  has_one :hibp, through: :service_hibp
  has_many :service_wikipedias
  has_many :wikipedias, through: :service_wikipedias

  has_many :reviews

  has_many :user_services
  has_many :users, through: :user_services

  has_many :service_categories
  has_many :categories, through: :service_categories

  validates :slug, uniqueness: true
  validates :name, presence: true # , uniqueness: true

  def privacymonitor_score
    if privacymonitor.present?
      minimum_score = 300.0
      maximum_score = 850.0 - 300.0
      current_score = privacymonitor.score.to_f - minimum_score
      final_score = current_score / maximum_score
      final_score
    end
  end

  def privacyscore_score
    unless privacyscores.empty?
      negative = []
      positive = []
      privacyscores.each do |factor|
        if factor.polarity == 'negative'
          negative << factor
        elsif factor.polarity == 'positive'
          positive << factor
        end
      end
      negative_weight = negative.count.to_f * 0.75
      positive_weight = positive.count.to_f * 0.25
      array = [negative_weight, positive_weight]
      final_score = positive_weight / array.sum(0.0)
    end
  end

  def pribot_score
    unless pribots.empty?
      negative = []
      positive = []
      pribots.each do |factor|
        if factor.polarity == 'negative'
          negative << factor
        elsif factor.polarity == 'positive'
          positive << factor
        end
      end
      negative_weight = negative.count.to_f * 1.5
      positive_weight = positive.count.to_f * 1.2
      total = negative_weight + positive_weight
      final_score = positive_weight / total
      final_score
    end
  end

  def tosdr_score
    unless tosdrs.empty?
      negative = []
      positive = []
      tosdrs.each do |factor|
        if factor.polarity == 'negative'
          negative << factor
        elsif factor.polarity == 'positive'
          positive << factor
        end
      end
      negative_weight = negative.count.to_f * 0.2
      positive_weight = positive.count.to_f * 0.8
      total = negative_weight + positive_weight
      final_score = positive_weight / total
      final_score
    end
  end

  def hibp_score
    if hibp.present?
      0.25
    else
      1
    end
  end

  def wikipedia_score
    if wikipedia.present?
      0.25
    else
      1
    end
  end

  def shout
    puts "SHOUT"
  end

  def pantherscore
    privacymonitor_score * 1
    privacyscore_score * 0.25
    pribot_score * 0.5
    tosdr_score * 0.75
    hibp_score * 1
    wikipedia_score * 1
  end

  def user_score
    reviews.count == 0 ? 0 : reviews.average(:rating).round(2)
  end
end

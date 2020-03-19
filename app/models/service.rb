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
      negative_weight = negative.count.to_f * 0.75 # Too many good points. Tests essential things.
      positive_weight = positive.count.to_f * 0.25
      array = [negative_weight, positive_weight]
      final_score = positive_weight / array.sum(0.0)
      final_score.nan? ? nil : final_score
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
      negative_weight = negative.count.to_f # Fairly balanced
      positive_weight = positive.count.to_f
      array = [negative_weight, positive_weight]
      final_score = positive_weight / array.sum(0.0)
      final_score.nan? ? nil : final_score
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
      negative_weight = negative.count.to_f * 0.2 # Biased to bad factors
      positive_weight = positive.count.to_f * 0.8
      array = [negative_weight, positive_weight]
      final_score = positive_weight / array.sum(0.0)
      final_score.nan? ? nil : final_score
    end
  end

  def hibp_score
    hibp.present? ? 0 : nil
  end

  def wikipedia_score
    wikipedias.present? ? 0 : nil
  end

  def calc_pantherscore
    scores = [
    [privacymonitor_score, 0.25],
    [privacyscore_score, 0.025],
    [pribot_score, 0.125],
    [tosdr_score, 0.1],
    [hibp_score, 0.25],
    [wikipedia_score, 0.25]
    ]
    available_sources = []
    calculated_sources = []
    total_weight = []
    scores.each do |score|
      if score[0].present?
        available_sources << score
        calculated_sources << score.inject(:*)
        weight = score[1]
        total_weight << weight
      end
    end
    if available_sources.empty?
      "N/A"
    elsif available_sources.count == 1 && available_sources[0] != privacymonitor_score
      "N/A"
    else
      decimal_score = calculated_sources.sum(0.0) / total_weight.sum(0.0)
      final_score = (decimal_score * 100).to_i
    end
  end

def jsonify_scores
  services = []
  Service.all.each do |service|
    services << {
    slug: service.slug,
    pantherscore: service.calc_pantherscore == 0 ? "N/A" : service.calc_pantherscore
    }
    File.open('./db/data/infosec/pantherscores.json', 'w') do |file|
      file.write(JSON.pretty_generate(services))
    end
  end
end

  def user_score
    reviews.count == 0 ? 0 : reviews.average(:rating).round(2)
  end
end

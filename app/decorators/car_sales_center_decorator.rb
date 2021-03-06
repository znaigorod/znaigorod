# encoding: utf-8

class CarSalesCenterDecorator < SuborganizationDecorator
  decorates :car_sales_center

  def viewable?
    features.any? || offers.any?
  end

  def title
    car_sales_center.title? ? car_sales_center.title : 'Автосалон'
  end

  def htmlise_features_on_show
    features.map {|f| h.content_tag(:li, f)}.join("\n").html_safe if features.any?
  end

  def htmlise_offers_on_show
    offers.map {|f| h.content_tag(:li, f)}.join("\n").html_safe if offers.any?
  end

  def htmlise_offers_and_features_on_show
    content = htmlise_offers_on_show.to_s + htmlise_features_on_show.to_s
    h.content_tag(:ul, content.html_safe, class: :offers_and_features) if content. present?
  end
end

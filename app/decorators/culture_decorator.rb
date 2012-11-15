# encoding: utf-8

class CultureDecorator < SuborganizationDecorator
  decorates :culture

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show
    characteristics_by_type("categories features offers")
  end

end

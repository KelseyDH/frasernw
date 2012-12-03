class NewsItem < ActiveRecord::Base
    
  def date
    if start_date_full.present? && end_date_full.present? && (start_date.to_s != end_date.to_s)
      "#{start_date_full} - #{end_date_full}"
    elsif start_date_full.present?
      start_date_full
    elsif end_date_full.present?
      end_date_full
    end
  end
  
  def start_date_full
    if show_start_date?
      start_date_full_regardless
    else
      ""
    end
  end
  
  def start_date_full_regardless
    if start_date.present?
      "#{start_date.strftime('%A %B')} #{start_date.day.ordinalize}"
    else
      ""
    end
  end
  
  def end_date_full
    if show_end_date?
      end_date_full_regardless
    else
      ""
    end
  end
  
  def end_date_full_regardless
    if end_date.present?
      "#{end_date.strftime('%A %B')} #{end_date.day.ordinalize}"
    else
      ""
    end
  end
    
  default_scope order('news_items.start_date')
  
  def self.breaking
    where("news_items.breaking = ? AND ((news_items.end_date IS NOT NULL AND news_items.end_date >= (?)) OR (news_items.end_date IS NULL AND news_items.start_date IS NOT NULL AND news_items.start_date >= (?)))", true, Date.today, Date.today)
  end
  
  def self.news
    where("news_items.breaking = ? AND ((news_items.end_date IS NOT NULL AND news_items.end_date >= (?)) OR (news_items.end_date IS NULL AND news_items.start_date IS NOT NULL AND news_items.start_date >= (?)))", false, Date.today, Date.today)
  end
end

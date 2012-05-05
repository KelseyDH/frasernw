class LanguageSweeper < ActionController::Caching::Sweeper
  observe Language
  
  def after_create(language)
    expire_cache_for(language)
  end
  
  def after_update(language)
    expire_cache_for(language)
  end
  
  def after_destroy(language)
    expire_cache_for(language)
  end
  
  def expire_cache_for(language)
    #expire language page
    expire_fragment :controller => 'languages', :action => 'show'
    
    #expire all the related pages in a delayed job
    Delayed::Job.enqueue LanguageCacheRefreshJob.new(language.id)
  end
  
  class LanguageCacheRefreshJob < Struct.new(:language_id)
    include ActionController::Caching::Actions
    include ActionController::Caching::Fragments
    include Net
    include Rails.application.routes.url_helpers # for url generation
    
    def perform
      language = Language.find(language_id)
      
      #expire search data
      expire_action :controller => 'search', :action => 'livesearch', :format => :js, :host => APP_CONFIG[:domain]
      #Net::HTTP.get( URI("http://#{APP_CONFIG[:domain]}/livesearch.js") )
      
      #expire all specialization pages (they list all languages)
      Specialization.all.each do |s|
        expire_fragment :controller => 'specializations', :action => 'show', :id => s.id, :host => APP_CONFIG[:domain]
        Net::HTTP.get( URI("http://#{APP_CONFIG[:domain]}/specializations/#{s.id}/#{s.token}/refresh_cache") )
      end
      
      #expire all procedures pages (they list all languages)
      Procedure.all.each do |p|
        expire_fragment :controller => 'procedures', :action => 'show', :id => p.id, :host => APP_CONFIG[:domain]
        Net::HTTP.get( URI("http://#{APP_CONFIG[:domain]}/procedures/#{p.id}/#{p.token}/refresh_cache") )
      end
      
      #expire all specialists that speak this language
      language.specialists.each do |s|
        expire_fragment :controller => 'specialists', :action => 'show', :id => s.id, :host => APP_CONFIG[:domain]
        Net::HTTP.get( URI("http://#{APP_CONFIG[:domain]}/specialists/#{s.id}/#{s.token}/refresh_cache") )
      end
      
      #expire all clinics that speak this language
      language.clinics.each do |c|
        expire_fragment :controller => 'clinics', :action => 'show', :id => c.id, :host => APP_CONFIG[:domain]
        Net::HTTP.get( URI("http://#{APP_CONFIG[:domain]}/clinics/#{c.id}/#{c.token}/refresh_cache") )
      end
      
    end
    
    private
    
    # The following methods are defined to fake out the ActionController
    # requirements of the Rails cache
    
    def cache_store
      ActionController::Base.cache_store
    end
    
    def self.benchmark( *params )
      yield
    end
    
    def cache_configured?
      true
    end
    
  end
end
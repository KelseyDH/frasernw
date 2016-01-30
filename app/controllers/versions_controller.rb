class VersionsController < ApplicationController
  load_and_authorize_resource

  SUPPORTED_KLASSES_FOR_SHOW = [
    Clinic,
    Specialist
  ]
  def show
    @version = Version.find(params[:id])
    if @version.reify.present? # fixes issue of first version record returning nil when reify is called on it
      @klass = @version.reify.class.to_s.downcase
      eval("@#{@klass} = @version.reify" )
    else
      @klass = @version.next.reify.class.to_s.downcase
      eval("@#{@klass} = @version.next.reify" )
    end
      eval("@feedback = @#{@klass}.active_feedback_items.build" )
      @is_version = true
      render :template => "#{@klass.pluralize}/show"

  end

  def show_all
    @versions = Version.order('id desc').no_blacklist.paginate(:page => params[:page], :per_page => 300)
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def revert
    @version = Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      if @version.item.specialization
        klass = @version.item.specialization.class.to_s.downcase.pluralize.to_sym
        @version.item.destroy
        redirect_to klass and return
      else
        redirect_to '/' and return
      end
    end
    link_name = params[:redo] == "true" ? "undo" : "redo"
    link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), :method => :post)
    redirect_to :back, :notice => "Undid #{@version.event}. #{link}"
  end

end

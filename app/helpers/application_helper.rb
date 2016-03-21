module ApplicationHelper

  def specialists_procedures(specialist)
    list = ""
    specialist.procedure_specializations.each do |ps|
      list += ps.procedure.name + (specialist.procedure_specializations.last == ps ? '' : ", ")
    end
    list
  end

  alias :clinics_procedures :specialists_procedures

  def procedure_ancestry(item, classification, specialization)
    process_nested_procedure_specializations = Proc.new do |nested_procedure_specializations|
      nested_procedure_specializations.inject([]) do |memo, (procedure_specialization, children)|
        memo << {
          parent: procedure_specialization.procedure,
          children: process_nested_procedure_specializations.call(children)
        }
      end.sort_by{|hsh| hsh[:parent].name }
    end

    # we take this roundabout path because we need to include
    # the procedure specializations' ancestors

    ids = item.
      procedure_specializations.
      classification(classification).
      for_specialization(specialization).
      map{|ps| (ps.ancestors + [ ps ]).map(&:id) }.
      flatten.
      uniq

    nested_procedure_specializations = ProcedureSpecialization.
      where("procedure_specializations.id IN (?)", ids).
      arrange

    process_nested_procedure_specializations.call(nested_procedure_specializations)
  end

  def compressed_procedures_indented(specialist_or_clinic, classification, specialty)
    compressed_procedures_indented_output(
      procedure_ancestry(specialist_or_clinic, classification, specialty),
      specialist_or_clinic
    )
  end

  def compressed_procedures_indented_output(items, root)
    return "", 0, false if items.empty?
    count = 0
    has_investigation = false
    result = "<ul>"
    items.each do |item|
      count += 1
      result += "<li>"
      result += "<strong><a class='ajax' href='#{procedure_path(item[:parent])}'>#{item[:parent].name}</a></strong>"
      investigation = item[:parent].procedure_specializations.map{ |ps| ps.investigation(root) }.reject{ |i| i.blank? }.map{ |i| i.punctuate }.join(' ');
      investigation = investigation.strip_period if investigation.present?
      if investigation and investigation.length > 0
        result += " (#{investigation})"
        has_investigation = true
      end
      if item[:children].present?
        child_results = []
        item[:children].each do |child|
          count += 1
          child_investigation = child[:parent].procedure_specializations.map{ |ps| ps.investigation(root) }.reject{ |i| i.blank? }.map{ |i| i.punctuate }.join(' ');
          child_investigation = child_investigation.strip_period if child_investigation.present?

          if child_investigation && child_investigation.strip.length != 0
            has_investigation = true
            child_results << "<a class='ajax' href='#{procedure_path(child[:parent])}'>#{child[:parent].name_relative_to_parents}</a> (#{child_investigation})"
          else
            child_results << "<a class='ajax' href='#{procedure_path(child[:parent])}'>#{child[:parent].name_relative_to_parents}</a>"
          end

          if child[:children].present?
            child[:children].each do |grandchild|
              count += 1
              grandchild_investigation = grandchild[:parent].procedure_specializations.map{ |ps| ps.investigation(root) }.reject{ |i| i.blank? }.map{ |i| i.punctuate }.join(' ');
              grandchild_investigation = grandchild_investigation.strip_period if grandchild_investigation.present?
              if grandchild_investigation && grandchild_investigation.strip.length != 0
                has_investigation = true
                child_results << "<a class='ajax' href='#{procedure_path(grandchild[:parent])}'>#{child[:parent].name_relative_to_parents} #{grandchild[:parent].name_relative_to_parents}</a> (#{grandchild_investigation})"
              else
                child_results << "<a class='ajax' href='#{procedure_path(grandchild[:parent])}'>#{child[:parent].name_relative_to_parents} #{grandchild[:parent].name_relative_to_parents}</a>"
              end
            end
          end
        end
        result += ": #{child_results.to_sentence}"
      end
      result += "</li>"
    end
    result += "</ul>"
    return result, count, has_investigation
  end

  def compressed_ancestry(procedure_specialization)
    result = ""
    while procedure_specialization.parent
      result = " > " + procedure_specialization.parent.procedure.name + result
      procedure_specialization = procedure_specialization.parent
    end
    procedure_specialization.specialization.name + result
  end

  def compressed_clinics(clinics)
    output = ''
    clinics.each do |clinic|
      output += (clinic.name + ', ')
    end
    output.gsub(/\,\ $/,'')
  end

  def ancestry_options(items, parent = "")
    result = []
    items.map do |item, sub_items|
      item_text = parent.empty? ? "#{item.procedure.name}" : "#{parent} #{item.procedure.name}"
      result << [ item_text, item.id]
      #this is a recursive call:
      result += ancestry_options(sub_items, item_text)
    end
    result
  end

  def default_owner
    return User.safe_find(10)
  end

  def default_content_owner
    return User.safe_find(3) #Ron
  end

  def user_guide
    ScItem.safe_find(953) # the Pathways User Guide content item pdf on production
  end

  def global_search_data
    GlobalSearchData.new.data
  end

  def search_data_labels
    SearchDataLabels.new
  end

  # bump this if you want to force clients to recache the data they store
  # in localStorage
  def localstorage_cache_version
    Setting.fetch(:localstorage_cache_version)
  end

  # # # # TOOLTIPS
  def show_tooltip(*args) # provides default tooltip behaviour for many icons, tooltips will not show unless bootstrap.js tooltip is initialized
    options = args.extract_options!
    return :title => options[:title] || "Title missing", :data => { toggle: "tooltip", placement: options[:placement] || "top", animation: options[:animation] || "true"}
  end

  def icon(icon_class, title=nil, placement="top") # icon will not have a tooltip unless a title is passed
    if title.present?
      "<i class='#{icon_class}' data-toggle='tooltip' data-original-title='#{title}' data-placement='#{placement}'></i>".html_safe
    else
      "<i class='#{icon_class}'></i>".html_safe
    end
  end

  def template_for_blue_tooltip #custom html needed for displaying the tooltips that we've customized for showing links that has blue styling
    '<div class="tooltip top blue" role="tooltip"><div class="tooltip-arrow blue"></div><div class="tooltip-inner"></div></div>'
  end
  # # # #

  def primary_support_email
    "administration@pathwaysbc.ca"
  end
end

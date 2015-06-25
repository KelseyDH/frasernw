require 'csv'

namespace :pathways do
  task :division_report, [:division, :start_date, :end_date] => :environment do |t, args|
    ### Defaults
    ### set for the K/B report atm
    args.with_defaults(
      start_date:  Date.civil(2015, 4, 16),
      end_date:    Date.civil(2015, 4, 30),
      division:    Division.find(7)
    )

    ### Get the data

    common_options = {
      start_date: args[:start_date],
      end_date:   args[:end_date],
      filters:    { division_id: args[:division].id }
    }

    total_pageviews =
      StatsReporter.page_views(common_options).first[:page_views]

    total_sessions = StatsReporter.sessions(common_options).first[:sessions]

    total_users =
      StatsReporter.total_users(common_options)

    page_views_by_page = StatsReporter.page_views(
      common_options.merge(dimensions: [:page_path, :user_type_key])
    )

    user_types = StatsReporter.user_types(common_options)
    user_types_table = HashTable.new(user_types)

    # transform user types table
    user_types_table.transform_column!(:page_views) do |row|
      row[:page_views].to_i
    end
    user_types_table.transform_column!(:sessions) do |row|
      row[:sessions].to_i
    end


    ## Transform pageviews table

    page_views_table = HashTable.new(page_views_by_page)

    # we want all of the page views to be integers so we can do arithmetic on them
    page_views_table.transform_column!(:page_views) do |row|
      row[:page_views].to_i
    end

    current_user_type_hash = User::TYPE_HASH.merge(
      -1 => "Bounced",
      0 => "Admin"
    )

    # collapse different users types for the same path down to one row per path
    # with the user type breakdown as columns
    page_views_table.collapse_subsets!(
      Proc.new { |row| row[:page_path] },
      {
        page_path: "",
        page_views: 0
      }.merge(current_user_type_hash.all_values(0)),
      Proc.new do |accumulator, row|
        accumulator.dup.merge(
          :page_path => row[:page_path],
          :page_views => accumulator[:page_views] + row[:page_views],
          row[:user_type_key].to_i =>  row[:page_views]
        )
      end
    )


    # add a column for resource name

    add_record_name = Proc.new do |table, path, records|
      table.transform_column!(:record_name) do |row|
        if row[:page_path][path]
          id_regexp = /(?<=#{Regexp.quote(path)})[[:digit:]]+/
          record_id = row[:page_path][id_regexp].to_i

          records.find{ |record| record.id == record_id }.try(:name)
        else
          row[:record_name]
        end
      end
    end

    add_record_name.call(
      page_views_table,
      "/specialties/",
      Specialization.all
    )
    add_record_name.call(
      page_views_table,
      "/content_items/",
      ScItem.all
    )
    add_record_name.call(
      page_views_table,
      "/content_categories/",
      ScCategory.all
    )
    add_record_name.call(
      page_views_table,
      "/areas_of_practice/",
      Procedure.all
    )

    collapse_by_path = Proc.new do |table, path|
      table.collapse_subset!(
        Proc.new {|row| row[:page_path][path] },
        {
          page_path: "#{path}*",
          page_views: 0
        }.merge(current_user_type_hash.all_values(0)),
        Proc.new do |accumulator, row|
          new_accumulator = accumulator.dup.merge(
            page_views: accumulator[:page_views] + row[:page_views],
          )

          current_user_type_hash.each do |key, value|
            if row[key].present?
              new_accumulator[key] = accumulator[key] + row[key]
            end
          end

          new_accumulator
        end
      )
    end

    collapse_by_path.call(page_views_table, "/specialists/")
    collapse_by_path.call(page_views_table, "/clinics/")
    collapse_by_path.call(page_views_table, "/users/")

    # sort by pathname
    page_views_table.rows.sort_by! {|row| row[:page_path]}


    ### Write the CSV

    timestamp = DateTime.now.to_s
    filename  = [
      "pathways_usage_report",
      args[:division].name,
      timestamp,
    ].join("_").safe_for_filename + ".csv"
    file_path = Rails.root.join("reports", "divisions", filename)

    CSV.open(file_path, "w+") do |csv|
      csv << [ "Pathways Usage Report"]
      csv << [ "Division: #{args[:division].name}"]
      csv << [ "Compiled on #{timestamp}" ]
      csv << [ "**All stats are for date range specified below***"]
      csv << [ ]
      csv << [ "Start Date"]
      csv << [ args[:start_date].to_s]
      csv << [ ]
      csv << [ "End Date"]
      csv << [ args[:end_date].to_s]
      csv << [ ]

      ### Summary Table
      csv << [ "SUMMARY" ]
      csv << [ "Total Pageviews", "Total Sessions", "Total Users"]
      csv << [ total_pageviews, total_sessions, total_users ]
      csv << [ ]

      ### User types table

      csv << [ "METRICS BY USER TYPE" ]
      csv << [ "User type", "Page Views", "Sessions"]
      user_types_table.rows.each do |row|
        csv << [
          current_user_type_hash[row[:user_type_key].to_i],
          row[:page_views],
          row[:sessions]
        ]
      end
      csv << [
        "All types",
        user_types_table.sum_column(:page_views),
        user_types_table.sum_column(:sessions)
      ]
      csv << [ ]

      ### Pageviews table

      csv << [ "METRICS BY PAGE" ]

      typed_pageview_headings = current_user_type_hash.keys.sort.map do |key|
        "Page Views (#{current_user_type_hash[key]})"
      end

      csv << ([ "Path", "Resource Name", "Total Page Views" ] + typed_pageview_headings )

      page_views_table.rows.each do |row|
        typed_pageviews = current_user_type_hash.keys.sort.map do |key|
          row[key] || 0
        end

        csv << ([ row[:page_path], row[:record_name], row[:page_views] ] + typed_pageviews)
      end

      typed_pageview_totals = current_user_type_hash.keys.sort.map do |key|
        page_views_table.sum_column(key)
      end
      csv << (["All paths", "", page_views_table.sum_column(:page_views)] + typed_pageview_totals)
    end
  end
end

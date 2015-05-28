# filter down by division, if there is a division
# filter down by path to resource category
# takes an abstract table, applies any necessary filters to it, and outputs table in array format (which the csv service can handle)
module Analytics
  module CsvPresenter
    # displays metrics by specialty name and user type
    class Resource < Base
      attr_reader :options

      def exec
        headings + body_rows
      end

      def data_source
        @data_source ||= QueryScope.new(
          Metric,
          metric: options[:metric],
          division_id: options[:division_id],
          path_regexp: '/content_items/\d+'
        )
      end

      def headings
        [
          [ title ],
          (["Path", "Resource", "User Type"] + months.map(&:name))
        ]
      end

      def resource_labeler
        @resource_labeler ||= Analytics::Labeler::Resource.new
      end

      def resource_paths
        @paths ||= data_source.all.map(&:page_path)
      end

      def body_rows
        resource_paths.inject([]) do |memo, path|
          memo + for_path(path)
        end
      end

      def for_path(path)
        total = data_source.aggregate(page_path: path)
        breakdown = data_source.aggregate(
          page_path: path,
          breakdown: :user_type_key
        )
        resource_label = resource_labeler.exec(total.page_path)

        result = [
          ([
            path,
            resource_label[:resource],
            resource_label[:category],
            "All user types",
          ] + months.map {|month| total[month] })
        ]

        result + breakdown.inject([]) do |memo, row|
          memo << ([
            "",
            "",
              user_type_labeler.exec(row.user_type_key),
          ] + months.map {|month| row[month] })
        end
      end
    end
  end
end

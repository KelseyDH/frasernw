module Api
  module V1
    class ReportsController < ApplicationController
      def page_views
        authorize! :view_report, :page_views

        render json: AnalyticsChart.exec(AnalyticsChartMonths.parse(params).merge(
          metric: :page_views
        ))
      end

      def sessions
        authorize! :view_report, :sessions

        render json: AnalyticsChart.exec(AnalyticsChartMonths.parse(params).merge(
          metric: :sessions
        ))
      end
    end
  end
end
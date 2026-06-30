module Admin
  class WeeklyDashboardsController < Admin::DashboardsController
    def index
      initial_date, final_date = extract_date_range

      @pf_immobile = ProjectField.to_hash(1, 0)
      @status_color = StatusDecoration.get_colors
      @status_deferred = StatusType.where(id: [6, 12, 24]).map(&:name)
      @status_def = StatusType.find_by(id: 7)&.name
      @range_dates = [[:year, 'Ano'], [:last_month, 'Mês Anterior'], [:month, 'Mês'], [:week, 'Semana']]

      path_image = Rails.root.join('app/assets/images/', '4.png')
      image_base64 = Base64.encode64(File.read(path_image))
      @image_url_base64 = "data:image/png;base64,#{image_base64}"

      @show_dashboard = initial_date.present? && final_date.present?

      redis_key = dashboard_redis_key(initial_date, final_date)
      cached_rates_present = $redis.hget(redis_key, 'rates_separated_by_technical_analysis').present?
      check_if_keys_exist = $redis.ttl(redis_key)

      if initial_date.blank? || final_date.blank?
        @there_are_no_keys = true
        WeeklyDashboardJob.perform_now if $redis.hget('user:general:main_counters', 'rates_separated_by_technical_analysis').nil?
        return
      end

      if check_if_keys_exist == -2 || !cached_rates_present
        @there_are_no_keys = true
        WeeklyDashboardJob.perform_now
      end

      project_ids = Counter.project_ids(initial_date: initial_date, final_date: final_date)
      @projects_count = project_ids.count
      @project_ids_by_dates = Counter.project_ids_by_dates(initial_date: initial_date, final_date: final_date)

      @projects_from_friday_to_friday = Counter.projects_from_friday_to_friday(initial_date: initial_date, final_date: final_date).count
      @ten_most_used_requirement = Counter.ten_most_used_requirement(initial_date: initial_date, final_date: final_date)
      @ten_most_used_monitoring = Counter.ten_most_used_monitoring(initial_date: initial_date, final_date: final_date)

      @project_completed = Counter.project_completed(initial_date: initial_date, final_date: final_date).count
      @project_completed_by_agency_and_status_types = Counter.project_completed_by_agency_and_status_types(initial_date: initial_date, final_date: final_date)

      @deferred_projects = Counter.deferred_projects(initial_date: initial_date, final_date: final_date).count
      @deferred = Counter.deferred_projects_by_dates(initial_date: initial_date, final_date: final_date)

      @closed_projects = Counter.closed_projects(initial_date: initial_date, final_date: final_date).count
      @closed = Counter.closed_projects_by_dates(initial_date: initial_date, final_date: final_date)

      @rejected_projects = Counter.rejected_projects(initial_date: initial_date, final_date: final_date).count
      @rejected = Counter.rejected_projects_by_dates(initial_date: initial_date, final_date: final_date)

      @total_fiscal = Counter.total_fiscal(initial_date: initial_date, final_date: final_date).count
      @total_fiscal_hash = Counter.total_fiscal_by_dates(initial_date: initial_date, final_date: final_date)

      @total_notification = Counter.total_notification(initial_date: initial_date, final_date: final_date).count
      @total_notification_hash = Counter.total_notification_by_dates(initial_date: initial_date, final_date: final_date)

      @reports = Counter.reports(initial_date: initial_date, final_date: final_date).count
      @online_service = Counter.reports_by_dates(initial_date: initial_date, final_date: final_date)

      @report_additionals = Counter.report_additionals_to_requester(initial_date: initial_date, final_date: final_date).count
      @report_additional_hash = Counter.report_additionals_to_requester_by_dates(initial_date: initial_date, final_date: final_date)

      @report_additionals2 = Counter.report_additionals_to_profile(initial_date: initial_date, final_date: final_date).count
      @report_additional_hash2 = Counter.report_additionals_to_profile_by_dates(initial_date: initial_date, final_date: final_date)

      @users = Counter.all_users(initial_date: initial_date, final_date: final_date).count
      @active_users = Counter.active_users(initial_date: initial_date, final_date: final_date).count
      @inactive_users = Counter.inactive_users(initial_date: initial_date, final_date: final_date).count
      @blocked_users = Counter.blocked_users(initial_date: initial_date, final_date: final_date).count
      @users_by_type = Counter.users_by_type(initial_date: initial_date, final_date: final_date)

      @agencies = Agency.where(active: true).where.not('name LIKE ?', '%acto%').map(&:name)

      histories_completed = $redis.hget('user:general:main_counters', 'flow_histories_completed').present? ? JSON.parse($redis.hget('user:general:main_counters', 'flow_histories_completed'), symbolize_names: true).size : 0
      @project_completed += histories_completed if histories_completed.present? && histories_completed > 0

      @completed_and_sent_of_the_year = Counter.completed_and_sent_of_the_year(initial_date: initial_date, final_date: final_date)
      @deferred_projects_with_agency_of_the_year = Counter.deferred_projects_with_agency_of_the_year(initial_date: initial_date, final_date: final_date)
      @data_for_the_treasury_chart = Counter.data_for_the_treasury_chart(initial_date: initial_date, final_date: final_date)
      @data_for_the_treasury_chart_for_agency = Counter.data_for_the_treasury_chart_for_agency(initial_date: initial_date, final_date: final_date)

      @project_done_counter = Counter.project_done_counter(initial_date: initial_date, final_date: final_date)
      @approved_building_counter = Counter.approved_building_counter(initial_date: initial_date, final_date: final_date)
      @project_and_certificate_counter = Counter.project_and_certificate_counter(initial_date: initial_date, final_date: final_date)
      @active_user_counter = Counter.active_user_counter(initial_date: initial_date, final_date: final_date)
      @approved_inhabit_counter = Counter.approved_inhabit_counter(initial_date: initial_date, final_date: final_date)
      @soil_use_counter = Counter.soil_use_counter(initial_date: initial_date, final_date: final_date)
      @project_upload_counter = Counter.project_upload_counter(initial_date: initial_date, final_date: final_date)
      @projects_separated_by_name_and_year = Counter.projects_separated_by_name_and_year(initial_date: initial_date, final_date: final_date)
      @get_status_for_charts_dashboard = Counter.get_status_for_charts_dashboard(initial_date: initial_date, final_date: final_date)
      @projects_separated_by_building_purpose = Counter.projects_separated_by_building_purpose(initial_date: initial_date, final_date: final_date)
      @process_separated_by_technical_analysis = Counter.process_separated_by_technical_analysis(initial_date: initial_date, final_date: final_date)
      @projects_separated_by_building_kind = Counter.projects_separated_by_building_kind(initial_date: initial_date, final_date: final_date)
      @tributary_separated_by_agency_and_year = Counter.tributary_separated_by_agency_and_year(initial_date: initial_date, final_date: final_date)
      @get_status_rates_for_charting_dashboard = Counter.get_status_rates_for_charting_dashboard(initial_date: initial_date, final_date: final_date)
      @rates_separated_by_building_purpose = Counter.rates_separated_by_building_purpose(initial_date: initial_date, final_date: final_date)
      @rates_separated_by_building_kind = Counter.rates_separated_by_building_kind(initial_date: initial_date, final_date: final_date)
      @rates_separated_by_technical_analysis = Counter.rates_separated_by_technical_analysis(initial_date: initial_date, final_date: final_date)
      @get_annual_revenue_chart = Counter.get_annual_revenue_chart(initial_date: initial_date, final_date: final_date)
      @project_layout_monitor_sum_work_total_area = Counter.project_layout_monitor_sum_work_total_area(initial_date: initial_date, final_date: final_date)
      @project_layout_monitor_sum_quantity_of_units = Counter.project_layout_monitor_sum_quantity_of_units(initial_date: initial_date, final_date: final_date)

      @list_of_charts = Hash.new
    end

    def generate_weekly_pdf
      initial_date, final_date = extract_date_range
      params[:date_range] = format_date_range(initial_date, final_date) if initial_date.present? && final_date.present?

      index
      logos
      @image_base64 = nil

      begin
        if @logo.present? && @logo[:right_system]&.image&.url.present?
          io = URI.open(@logo[:right_system].image.url)
          @image_base64 = Base64.encode64(io.read)
        end
      rescue Exception => e
        puts '###############################'
        puts e.message
        puts e.backtrace.join("\n")
        puts '###############################'
      end

      pdf = WickedPdf.new.pdf_from_string(
        render_to_string(template: 'admin/dashboards/weekly_dashboard_pdf.html.erb', layout: 'layouts/weekly_dashboard_pdf.html.erb'),
        enable_local_file_access: true,
        page_size: 'A4',
        margin: { top: 5, bottom: 5, left: 0, right: 0 },
        default_header: false,
        background: true,
        javascript_delay: 2000,
        disable_internal_links: false,
        disable_external_links: false,
        encoding: 'UTF-8'
      )
      filename = "#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_boletim_acto.pdf"
      send_data pdf, filename: filename
    end

    def generate_weekly_xls
      index

      filename = "#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_boletim_acto.xlsx"

      respond_to do |format|
        format.xlsx { render xlsx: 'generate_weekly_xls', filename: filename }
      end
    end

    def logos
      server_id =
        if Rails.env.include?('olimpia')
          1
        elsif Rails.env.include?('rioclaro')
          3
        elsif Rails.env.include?('suzano')
          4
        elsif Rails.env.include?('santoandre')
          5
        elsif Rails.env.include?('cordeiropolis')
          6
        elsif Rails.env.include?('extrema')
          7
        elsif Rails.env.include?('cedral')
          8
        else
          2
        end

      @logo = {}
      @logo[:top_login] = ConstantHandler.logo_image(1, server_id)
      @logo[:bottom_login] = ConstantHandler.logo_image(2, server_id)
      @logo[:left_system] = ConstantHandler.logo_image(3, server_id)
      @logo[:right_system] = ConstantHandler.logo_image(4, server_id)
      @logo
    end

    private

    def extract_date_range
      if params[:date_range].present?
        dates = params[:date_range].split(':')
        [dates[0].gsub('/', '-'), dates[1].gsub('/', '-')]
      elsif params[:initial_date].present? && params[:final_date].present?
        [params[:initial_date], params[:final_date]]
      else
        [nil, nil]
      end
    end

    def dashboard_redis_key(initial_date, final_date)
      if initial_date.present? && final_date.present?
        "user:general:main_counters:#{initial_date}:#{final_date}"
      else
        'user:general:main_counters'
      end
    end

    def format_date_range(initial_date, final_date)
      return nil if initial_date.blank? || final_date.blank?

      "#{initial_date}:#{final_date}"
    end
  end
end

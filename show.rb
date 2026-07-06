class Counter < ApplicationRecord
  belongs_to :number_kind
  has_and_belongs_to_many :services, join_table: :counters_and_services, optional: true
  has_and_belongs_to_many :status_types, join_table: :counters_and_status_types, optional: true

  def self.count_service(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "count_service")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      project ||= Project.not_on_creation
      counter_data = {
        atualizacao_projeto:
        {
          hoje: project.where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day).count,
          semana: project.where(updated_at: Date.today.beginning_of_week..Date.today.end_of_week).count,
          ultimos_sete: project.where(updated_at: (Date.today - 6.days)..Date.today).count,
          mes: project.where(updated_at: Date.today.beginning_of_month..Date.today.end_of_month).count,
          ultimos_trinta: project.where(updated_at: (Date.today - 29.days)..Date.today).count,
          ano: project.where(updated_at: Date.today.beginning_of_year..Date.today.end_of_year).count,
          um_ano_atras: project.where(updated_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year).count,
          dois_anos_atras: project.where(updated_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year).count,
          tres_anos_atras: project.where(updated_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year).count,
          quatro_anos_atras: project.where(updated_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year).count,
          total: project.count
        },
        deferidos:
        {
          hoje: project.where(project_end: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 7).count,
          semana: project.where(project_end: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 7).count,
          ultimos_sete: project.where(project_end: (Date.today - 6.days)..Date.today, status_type_id: 7).count,
          mes: project.where(project_end: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 7).count,
          ultimos_trinta: project.where(project_end: (Date.today - 29.days)..Date.today, status_type_id: 7).count,
          ano: project.where(project_end: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 7).count,
          um_ano_atras: project.where(project_end: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 7).count,
          dois_anos_atras: project.where(project_end: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 7).count,
          tres_anos_atras: project.where(project_end: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 7).count,
          quatro_anos_atras: project.where(project_end: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 7).count,
          total: project.where(status_type_id: 7).count
        },
        indeferidos:
        {
          hoje: project.where(project_end: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 8).count,
          semana: project.where(project_end: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 8).count,
          ultimos_sete: project.where(project_end: (Date.today - 6.days)..Date.today, status_type_id: 8).count,
          mes: project.where(project_end: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 8).count,
          ultimos_trinta: project.where(project_end: (Date.today - 29.days)..Date.today, status_type_id: 8).count,
          ano: project.where(project_end: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 8).count,
          um_ano_atras: project.where(project_end: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 8).count,
          dois_anos_atras: project.where(project_end: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 8).count,
          tres_anos_atras: project.where(project_end: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 8).count,
          quatro_anos_atras: project.where(project_end: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 8).count,
          total: project.where(status_type_id: 8).count
        },
        encerrado:
        {
          hoje: project.where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 9).count,
          semana: project.where(updated_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 9).count,
          ultimos_sete: project.where(updated_at: (Date.today - 6.days)..Date.today, status_type_id: 9).count,
          mes: project.where(updated_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 9).count,
          ultimos_trinta: project.where(updated_at: (Date.today - 29.days)..Date.today, status_type_id: 9).count,
          ano: project.where(updated_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 9).count,
          um_ano_atras: project.where(updated_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 9).count,
          dois_anos_atras: project.where(updated_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 9).count,
          tres_anos_atras: project.where(updated_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 9).count,
          quatro_anos_atras: project.where(updated_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 9).count,
          total: project.where(status_type_id: 9).count
        },
        concluidos:
        {
          hoje: project.where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: [6,7,8,9]).count,
          semana: project.where(updated_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: [6,7,8,9]).count,
          ultimos_sete: project.where(updated_at: (Date.today - 6.days)..Date.today, status_type_id: [6,7,8,9]).count,
          mes: project.where(updated_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: [6,7,8,9]).count,
          ultimos_trinta: project.where(updated_at: (Date.today - 29.days)..Date.today, status_type_id: [6,7,8,9]).count,
          ano: project.where(updated_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: [6,7,8,9]).count,
          um_ano_atras: project.where(updated_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: [6,7,8,9]).count,
          dois_anos_atras: project.where(updated_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: [6,7,8,9]).count,
          tres_anos_atras: project.where(updated_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: [6,7,8,9]).count,
          quatro_anos_atras: project.where(updated_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: [6,7,8,9]).count,
          total: project.where(status_type_id: [6,7,8,9]).count
        },
        lançados:
        {
          hoje: project.where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: [26,27]).count,
          semana: project.where(updated_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: [26,27]).count,
          ultimos_sete: project.where(updated_at: (Date.today - 6.days)..Date.today, status_type_id: [26,27]).count,
          mes: project.where(updated_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: [26,27]).count,
          ultimos_trinta: project.where(updated_at: (Date.today - 29.days)..Date.today, status_type_id: [26,27]).count,
          ano: project.where(updated_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: [26,27]).count,
          um_ano_atras: project.where(updated_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: [26,27]).count,
          dois_anos_atras: project.where(updated_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: [26,27]).count,
          tres_anos_atras: project.where(updated_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: [26,27]).count,
          quatro_anos_atras: project.where(updated_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: [26,27]).count,
          total: project.where(status_type_id: [26,27]).count
        },
        arquivados:
        {
          hoje: project.where(updated_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 15).count,
          semana: project.where(updated_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 15).count,
          ultimos_sete: project.where(updated_at: (Date.today - 6.days)..Date.today, status_type_id: 15).count,
          mes: project.where(updated_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 15).count,
          ultimos_trinta: project.where(updated_at: (Date.today - 29.days)..Date.today, status_type_id: 15).count,
          ano: project.where(updated_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 15).count,
          um_ano_atras: project.where(updated_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 15).count,
          dois_anos_atras: project.where(updated_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 15).count,
          tres_anos_atras: project.where(updated_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 15).count,
          quatro_anos_atras: project.where(updated_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 15).count,
          total: project.where(status_type_id: 15).count
        },
      }
      $redis.hset(counter_key, "count_service", counter_data.to_json)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.count_process_on_pending(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "count_process_on_pending")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      project ||= Project.not_on_creation
      counter_data = {
        conferir_documento:
        {
          hoje: Report.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 2, project_id: project.pluck(:id)).count,
          semana: Report.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 2, project_id: project.pluck(:id)).count,
          ultimos_sete: Report.where(created_at: (Date.today - 6.days)..Date.today, status_type_id: 2, project_id: project.pluck(:id)).count,
          mes: Report.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 2, project_id: project.pluck(:id)).count,
          ultimos_trinta: Report.where(created_at: (Date.today - 29.days)..Date.today, status_type_id: 2, project_id: project.pluck(:id)).count,
          ano: Report.where(created_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 2, project_id: project.pluck(:id)).count,
          um_ano_atras: Report.where(created_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 2, project_id: project.pluck(:id)).count,
          dois_anos_atras: Report.where(created_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 2, project_id: project.pluck(:id)).count,
          tres_anos_atras: Report.where(created_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 2, project_id: project.pluck(:id)).count,
          quatro_anos_atras: Report.where(created_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 2, project_id: project.pluck(:id)).count,
          total: Report.where(status_type_id: 2, project_id: project.pluck(:id)).count
        },
        analise_tributaria:
        {
          hoje: Report.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 10, project_id: project.pluck(:id)).count,
          semana: Report.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 10, project_id: project.pluck(:id)).count,
          ultimos_sete: Report.where(created_at: (Date.today - 6.days)..Date.today, status_type_id: 10, project_id: project.pluck(:id)).count,
          mes: Report.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 10, project_id: project.pluck(:id)).count,
          ultimos_trinta: Report.where(created_at: (Date.today - 29.days)..Date.today, status_type_id: 10, project_id: project.pluck(:id)).count,
          ano: Report.where(created_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 10, project_id: project.pluck(:id)).count,
          um_ano_atras: Report.where(created_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 10, project_id: project.pluck(:id)).count,
          dois_anos_atras: Report.where(created_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 10, project_id: project.pluck(:id)).count,
          tres_anos_atras: Report.where(created_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 10, project_id: project.pluck(:id)).count,
          quatro_anos_atras: Report.where(created_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 10, project_id: project.pluck(:id)).count,
          total: Report.where(status_type_id: 10, project_id: project.pluck(:id)).count
        },
        aguardando_pagamento:
        {
          hoje: Report.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 11, project_id: project.pluck(:id)).count,
          semana: Report.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 11, project_id: project.pluck(:id)).count,
          ultimos_sete: Report.where(created_at: (Date.today - 6.days)..Date.today, status_type_id: 11, project_id: project.pluck(:id)).count,
          mes: Report.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 11, project_id: project.pluck(:id)).count,
          ultimos_trinta: Report.where(created_at: (Date.today - 29.days)..Date.today, status_type_id: 11, project_id: project.pluck(:id)).count,
          ano: Report.where(created_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 11, project_id: project.pluck(:id)).count,
          um_ano_atras: Report.where(created_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 11, project_id: project.pluck(:id)).count,
          dois_anos_atras: Report.where(created_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 11, project_id: project.pluck(:id)).count,
          tres_anos_atras: Report.where(created_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 11, project_id: project.pluck(:id)).count,
          quatro_anos_atras: Report.where(created_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 11, project_id: project.pluck(:id)).count,
          total: Report.where(status_type_id: 11, project_id: project.pluck(:id)).count
        },
        analise_tecnica:
        {
          hoje: Report.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 3, project_id: project.pluck(:id)).count,
          semana: Report.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 3, project_id: project.pluck(:id)).count,
          ultimos_sete: Report.where(created_at: (Date.today - 6.days)..Date.today, status_type_id: 3, project_id: project.pluck(:id)).count,
          mes: Report.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 3, project_id: project.pluck(:id)).count,
          ultimos_trinta: Report.where(created_at: (Date.today - 29.days)..Date.today, status_type_id: 3, project_id: project.pluck(:id)).count,
          ano: Report.where(created_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 3, project_id: project.pluck(:id)).count,
          um_ano_atras: Report.where(created_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 3, project_id: project.pluck(:id)).count,
          dois_anos_atras: Report.where(created_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 3, project_id: project.pluck(:id)).count,
          tres_anos_atras: Report.where(created_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 3, project_id: project.pluck(:id)).count,
          quatro_anos_atras: Report.where(created_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 3, project_id: project.pluck(:id)).count,
          total: Report.where(status_type_id: 3, project_id: project.pluck(:id)).count
        },
        redacao_final:
        {
          hoje: Report.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 4, project_id: project.pluck(:id)).count,
          semana: Report.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 4, project_id: project.pluck(:id)).count,
          ultimos_sete: Report.where(created_at: (Date.today - 6.days)..Date.today, status_type_id: 4, project_id: project.pluck(:id)).count,
          mes: Report.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 4, project_id: project.pluck(:id)).count,
          ultimos_trinta: Report.where(created_at: (Date.today - 29.days)..Date.today, status_type_id: 4, project_id: project.pluck(:id)).count,
          ano: Report.where(created_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 4, project_id: project.pluck(:id)).count,
          um_ano_atras: Report.where(created_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 4, project_id: project.pluck(:id)).count,
          dois_anos_atras: Report.where(created_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 4, project_id: project.pluck(:id)).count,
          tres_anos_atras: Report.where(created_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 4, project_id: project.pluck(:id)).count,
          quatro_anos_atras: Report.where(created_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 4, project_id: project.pluck(:id)).count,
          total: Report.where(status_type_id: 4, project_id: project.pluck(:id)).count
        },
        deferimento:
        {
          hoje: Report.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 5, project_id: project.pluck(:id)).count,
          semana: Report.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 5, project_id: project.pluck(:id)).count,
          ultimos_sete: Report.where(created_at: (Date.today - 6.days)..Date.today, status_type_id: 5, project_id: project.pluck(:id)).count,
          mes: Report.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 5, project_id: project.pluck(:id)).count,
          ultimos_trinta: Report.where(created_at: (Date.today - 29.days)..Date.today, status_type_id: 5, project_id: project.pluck(:id)).count,
          ano: Report.where(created_at: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 5, project_id: project.pluck(:id)).count,
          um_ano_atras: Report.where(created_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 5, project_id: project.pluck(:id)).count,
          dois_anos_atras: Report.where(created_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 5, project_id: project.pluck(:id)).count,
          tres_anos_atras: Report.where(created_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 5, project_id: project.pluck(:id)).count,
          quatro_anos_atras: Report.where(created_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 5, project_id: project.pluck(:id)).count,
          total: Report.where(status_type_id: 5, project_id: project.pluck(:id)).count
        },
        outros:
        {
          hoje: Report.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          semana: Report.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          ultimos_sete: Report.where(created_at: (Date.today - 6.days)..Date.today, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          mes: Report.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          ultimos_trinta: Report.where(created_at: (Date.today - 29.days)..Date.today, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          ano: Report.where(created_at: Date.today.beginning_of_year..Date.today.end_of_year, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          um_ano_atras: Report.where(created_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          dois_anos_atras: Report.where(created_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          tres_anos_atras: Report.where(created_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          quatro_anos_atras: Report.where(created_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count,
          total: Report.where(project_id: project.pluck(:id)).where.not(status_type_id: [2,10,11,3,4,5]).count
        },
        total:
        {
          hoje: Report.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, project_id: project.pluck(:id)).count,
          semana: Report.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week, project_id: project.pluck(:id)).count,
          ultimos_sete: Report.where(created_at: (Date.today - 6.days)..Date.today, project_id: project.pluck(:id)).count,
          mes: Report.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, project_id: project.pluck(:id)).count,
          ultimos_trinta: Report.where(created_at: (Date.today - 29.days)..Date.today, project_id: project.pluck(:id)).count,
          ano: Report.where(created_at: Date.today.beginning_of_year..Date.today.end_of_year, project_id: project.pluck(:id)).count,
          um_ano_atras: Report.where(created_at: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, project_id: project.pluck(:id)).count,
          dois_anos_atras: Report.where(created_at: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, project_id: project.pluck(:id)).count,
          tres_anos_atras: Report.where(created_at: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, project_id: project.pluck(:id)).count,
          quatro_anos_atras: Report.where(created_at: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, project_id: project.pluck(:id)).count,
          total: Report.where(project_id: project.pluck(:id)).count
        },
      }
      $redis.hset(counter_key, "count_process_on_pending", counter_data.to_json)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.count_process_on_done(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "count_process_on_done")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      project ||= Project.not_on_creation
      counter_data = {
        deferido:
        {
          hoje: project.where(project_end: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: [6,7]).count,
          semana: project.where(project_end: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: [6,7]).count,
          ultimos_sete: project.where(project_end: (Date.today - 6.days)..Date.today, status_type_id: [6,7]).count,
          mes: project.where(project_end: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: [6,7]).count,
          ultimos_trinta: project.where(project_end: (Date.today - 29.days)..Date.today, status_type_id: [6,7]).count,
          ano: project.where(project_end: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: [6,7]).count,
          um_ano_atras: project.where(project_end: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: [6,7]).count,
          dois_anos_atras: project.where(project_end: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: [6,7]).count,
          tres_anos_atras: project.where(project_end: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: [6,7]).count,
          quatro_anos_atras: project.where(project_end: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: [6,7]).count,
          total: project.where(status_type_id: [6,7]).count
        },
        indeferido:
        {
          hoje: project.where(project_end: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 8).count,
          semana: project.where(project_end: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 8).count,
          ultimos_sete: project.where(project_end: (Date.today - 6.days)..Date.today, status_type_id: 8).count,
          mes: project.where(project_end: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 8).count,
          ultimos_trinta: project.where(project_end: (Date.today - 29.days)..Date.today, status_type_id: 8).count,
          ano: project.where(project_end: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 8).count,
          um_ano_atras: project.where(project_end: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 8).count,
          dois_anos_atras: project.where(project_end: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 8).count,
          tres_anos_atras: project.where(project_end: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 8).count,
          quatro_anos_atras: project.where(project_end: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 8).count,
          total: project.where(status_type_id: 8).count
        },
        encerrado:
        {
          hoje: project.where(project_end: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 9).count,
          semana: project.where(project_end: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 9).count,
          ultimos_sete: project.where(project_end: (Date.today - 6.days)..Date.today, status_type_id: 9).count,
          mes: project.where(project_end: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 9).count,
          ultimos_trinta: project.where(project_end: (Date.today - 29.days)..Date.today, status_type_id: 9).count,
          ano: project.where(project_end: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 9).count,
          um_ano_atras: project.where(project_end: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 9).count,
          dois_anos_atras: project.where(project_end: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 9).count,
          tres_anos_atras: project.where(project_end: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 9).count,
          quatro_anos_atras: project.where(project_end: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 9).count,
          total: project.where(status_type_id: 9).count
        },
        arquivado:
        {
          hoje: project.where(project_end: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 15).count,
          semana: project.where(project_end: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 15).count,
          ultimos_sete: project.where(project_end: (Date.today - 6.days)..Date.today, status_type_id: 15).count,
          mes: project.where(project_end: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 15).count,
          ultimos_trinta: project.where(project_end: (Date.today - 29.days)..Date.today, status_type_id: 15).count,
          ano: project.where(project_end: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 15).count,
          um_ano_atras: project.where(project_end: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 15).count,
          dois_anos_atras: project.where(project_end: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 15).count,
          tres_anos_atras: project.where(project_end: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 15).count,
          quatro_anos_atras: project.where(project_end: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 15).count,
          total: project.where(status_type_id: 15).count
        },
        cancelado:
        {
          hoje: project.where(project_end: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 12).count,
          semana: project.where(project_end: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 12).count,
          ultimos_sete: project.where(project_end: (Date.today - 6.days)..Date.today, status_type_id: 12).count,
          mes: project.where(project_end: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 12).count,
          ultimos_trinta: project.where(project_end: (Date.today - 29.days)..Date.today, status_type_id: 12).count,
          ano: project.where(project_end: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 12).count,
          um_ano_atras: project.where(project_end: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 12).count,
          dois_anos_atras: project.where(project_end: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 12).count,
          tres_anos_atras: project.where(project_end: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 12).count,
          quatro_anos_atras: project.where(project_end: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 12).count,
          total: project.where(status_type_id: 12).count
        },
        vencido:
        {
          hoje: project.where(project_end: Date.today.beginning_of_day..Date.today.end_of_day, status_type_id: 24).count,
          semana: project.where(project_end: Date.today.beginning_of_week..Date.today.end_of_week, status_type_id: 24).count,
          ultimos_sete: project.where(project_end: (Date.today - 6.days)..Date.today, status_type_id: 24).count,
          mes: project.where(project_end: Date.today.beginning_of_month..Date.today.end_of_month, status_type_id: 24).count,
          ultimos_trinta: project.where(project_end: (Date.today - 29.days)..Date.today, status_type_id: 24).count,
          ano: project.where(project_end: Date.today.beginning_of_year..Date.today.end_of_year, status_type_id: 24).count,
          um_ano_atras: project.where(project_end: (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year, status_type_id: 24).count,
          dois_anos_atras: project.where(project_end: (Date.today - 2.year).beginning_of_year..(Date.today - 2.year).end_of_year, status_type_id: 24).count,
          tres_anos_atras: project.where(project_end: (Date.today - 3.year).beginning_of_year..(Date.today - 3.year).end_of_year, status_type_id: 24).count,
          quatro_anos_atras: project.where(project_end: (Date.today - 4.year).beginning_of_year..(Date.today - 4.year).end_of_year, status_type_id: 24).count,
          total: project.where(status_type_id: 24).count
        },
      }
      $redis.hset(counter_key, "count_process_on_done", counter_data.to_json)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.today_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "today_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.today.count
      $redis.hset(counter_key, "today_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.yesterday_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "yesterday_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.yesterday.count
      $redis.hset(counter_key, "yesterday_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.seven_days_before_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "seven_days_before_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.seven_days_before.count
      $redis.hset(counter_key, "seven_days_before_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.this_week_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "this_week_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.this_week.count
      $redis.hset(counter_key, "this_week_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.thirty_days_before_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "thirty_days_before_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.thirty_days_before.count
      $redis.hset(counter_key, "thirty_days_before_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.this_month_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "this_month_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.this_month.count
      $redis.hset(counter_key, "this_month_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.year_now_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "year_now_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.year_now.count
      $redis.hset(counter_key, "year_now_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.year_less_one_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "year_less_one_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.year_less_one.count
      $redis.hset(counter_key, "year_less_one_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.year_less_two_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "year_less_two_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.year_less_two.count
      $redis.hset(counter_key, "year_less_two_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.year_less_three_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "year_less_three_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.year_less_three.count
      $redis.hset(counter_key, "year_less_three_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.year_less_four_count(project=nil,current_access=nil, current_user=nil, current_profile=nil, current_agency=nil)
    counter_key =  get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, "year_less_four_count")
    if !counter_data
      project ||= Project.not_on_creation
      counter_data = project.year_less_four.count
      $redis.hset(counter_key, "year_less_four_count", counter_data)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.filter_projects_by_agency(scope, agency_ids)
    return scope unless agency_ids.present?

    scope.joins(:agency).where(agencies: { id: agency_ids })
  end

  def self.base_project_scope(agency_ids)
    filter_projects_by_agency(Project.not_on_creation, agency_ids)
  end

  def self.project_done_counter(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "project_done_counter")
    if !counter_data
      scope = filter_projects_by_agency(Project.where(status_type_id: Project::COMPLETED), agency_ids)

      if initial_date.present? && final_date.present?
        scope = scope.projects_in_range(initial_date, final_date, 'project_end')
      end
      counter_data = scope.count

      $redis.hset(counter_key, "project_done_counter", counter_data)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data.to_i
  end

  def self.approved_building_counter(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "approved_building_counter")
    if !counter_data
      counter = self.joins(:services, :status_types).where(number_kind_id: 1).distinct
      scope = filter_projects_by_agency(Project.where(service_id: counter.pluck(:service_id), status_type_id: counter.pluck(:status_type_id)), agency_ids)

      if initial_date.present? && final_date.present?
        scope = scope.projects_in_range(initial_date, final_date, 'project_start')
      end

      counter_data = scope.joins(:project_layout).sum(:total_of_the_work).to_f
      $redis.hset(counter_key, "approved_building_counter", counter_data)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data.to_f
  end

  def self.approved_inhabit_counter(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "approved_inhabit_counter")
    if !counter_data
      counter = self.joins(:services, :status_types).where(number_kind_id: 4).distinct
      scope = filter_projects_by_agency(Project.where(service_id: counter.pluck(:service_id), status_type_id: counter.pluck(:status_type_id)), agency_ids)

      if initial_date.present? && final_date.present?
        scope = scope.projects_in_range(initial_date, final_date, 'project_start')
      end

      counter_data = scope.joins(:project_to_monitor_work_dimension).sum(:total_of_the_work_confirmed).to_f
      $redis.hset(counter_key, "approved_inhabit_counter", counter_data)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data.to_f
  end

  def self.project_and_certificate_counter(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "project_and_certificate_counter")
    if !counter_data
      counter = self.joins(:services, :status_types).where(number_kind_id: 2).distinct
      scope = filter_projects_by_agency(Project.where(service_id: counter.pluck(:service_id), status_type_id: counter.pluck(:status_type_id)), agency_ids)

      if initial_date.present? && final_date.present?
        scope = scope.projects_in_range(initial_date, final_date, 'project_start')
      end

      counter_data = scope.count
      $redis.hset(counter_key, "project_and_certificate_counter", counter_data)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data.to_i
  end

  def self.soil_use_counter(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "soil_use_counter")
    if !counter_data
      counter = self.joins(:services, :status_types).where(number_kind_id: 3).distinct
      scope = filter_projects_by_agency(Project.where(service_id: counter.pluck(:service_id), status_type_id: counter.pluck(:status_type_id)), agency_ids)

      if initial_date.present? && final_date.present?
        scope = scope.projects_in_range(initial_date, final_date, 'project_start')
      end

      counter_data = scope.count
      $redis.hset(counter_key, "soil_use_counter", counter_data)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data.to_i
  end

  def self.project_upload_counter(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "project_upload_counter")
    if !counter_data
      scope = ProjectUpload.all
      if initial_date.present? && final_date.present?
        start_date = Time.parse(initial_date).beginning_of_day
        end_date = Time.parse(final_date).end_of_day
        scope = scope.where(created_at: start_date..end_date)
      end

      counter_data = scope.count
      $redis.hset(counter_key, "project_upload_counter", counter_data)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data.to_i
  end


  def self.project_ids(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "project_ids")
    if counter_data
      counter_data = JSON.parse(counter_data)
    else
      scope = base_project_scope(agency_ids)

      if initial_date.present? && final_date.present?
        scope = scope.projects_in_range(initial_date, final_date, 'project_start')
      end

      counter_data = scope.distinct.ids

      $redis.hset(counter_key, "project_ids", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.project_ids_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    
    # Don't use cache when agency_ids are present (or always recompute for accuracy)
    if agency_ids.blank?
      counter_data = $redis.hget(counter_key, "project_ids_by_dates")
    else
      counter_data = nil  # Skip cache for filtered requests
    end
    
    if !counter_data
      # Build base scope with agency filtering
      scope = base_project_scope(agency_ids).distinct
      
      # Use the scope directly
      counter_data = scope.sizes_by_dates(:project_start, initial_date: initial_date, final_date: final_date)
      
      $redis.hset(counter_key, "project_ids_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    else
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    end
    counter_data
  end
 
  def self.projects_from_friday_to_friday(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "projects_from_friday_to_friday")

    if counter_data
      counter_data = JSON.parse(counter_data)
    else
      base_scope =
        if projects
          projects
        else
          Project.where(
            id: project_ids(
              current_access, current_user, current_profile, current_agency,
              initial_date: initial_date, final_date: final_date, agency_ids: agency_ids
            )
          ).where.not(status_type_id: 1)
        end

      base_scope = filter_projects_by_agency(base_scope, agency_ids) if projects

      counter_data = base_scope.from_friday_to_friday(:project_start, initial_date: initial_date).ids

      $redis.hset(counter_key, "projects_from_friday_to_friday", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end

    counter_data
  end

  def self.active_user_counter(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "active_user_counter")

    if !counter_data
      if initial_date.present? && final_date.present?
        start_date = Time.parse(initial_date).beginning_of_day
        end_date = Time.parse(final_date).end_of_day
        counter_data = User.active.where(created_at: start_date..end_date).count
      else
        counter_data = User.active.count
      end

      $redis.hset(counter_key, "active_user_counter", counter_data)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end

    counter_data.to_i
  end

  def self.ten_most_used_requirement(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil,projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "ten_most_used_requirement")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      projects = filter_projects_by_agency(projects, agency_ids) if projects
      counter_data = projects ? projects.ten_most_used_requirement : Project.where(id: projects_from_friday_to_friday(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).ten_most_used_requirement
      $redis.hset(counter_key, "ten_most_used_requirement", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.ten_most_used_monitoring(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil,projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "ten_most_used_monitoring")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      projects = filter_projects_by_agency(projects, agency_ids) if projects
      counter_data = projects ? projects.ten_most_used_monitoring : Project.where(id: projects_from_friday_to_friday(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).ten_most_used_monitoring
      $redis.hset(counter_key, "ten_most_used_monitoring", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.reports_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "reports_by_dates")
    if !counter_data
      # Build base scope - filter reports through project's agency
      scope = if agency_ids.present?
        Report.joins(project: :agency).where(agencies: { id: agency_ids }).distinct
      else
        Report.all
      end
      
      ids = scope.pluck(:id)
      counter_data = if ids.present?
        scope.where(id: ids).sizes_by_dates(:created_at, initial_date: initial_date, final_date: final_date)
      else
        { year: 0, month: 0, last_month: 0, week: 0 }
      end
      
      $redis.hset(counter_key, "reports_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    else
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    end
    counter_data
  end

  def self.deferred_projects(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil,projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "deferred_projects")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      projects = filter_projects_by_agency(projects, agency_ids) if projects
      if initial_date.present? && final_date.present?
        counter_data = projects ? projects.deferred.projects_in_range(initial_date, final_date, 'project_end').ids : Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).deferred.projects_in_range(initial_date, final_date, 'project_end').ids
      else
        counter_data = projects ? projects.deferred.ids : Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).deferred.ids
      end
      $redis.hset(counter_key, "deferred_projects", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.deferred_projects_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "deferred_projects_by_dates")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      ids = deferred_projects(
        current_access, current_user, current_profile, current_agency,
        nil,
        initial_date: initial_date, final_date: final_date, agency_ids: agency_ids, expire_key: expire_key
      )
      counter_data = Project.where(id: ids).sizes_by_dates(:project_end, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "deferred_projects_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.closed_projects(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil,projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "closed_projects")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      projects = filter_projects_by_agency(projects, agency_ids) if projects
      if initial_date.present? && final_date.present?
        counter_data = projects ? projects.projects_in_range(initial_date, final_date, 'project_end').on_closed.ids : Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).projects_in_range(initial_date, final_date, 'project_end').on_closed.ids
      else
        counter_data = projects ? projects.on_closed.ids : Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).on_closed.ids
      end
      $redis.hset(counter_key, "closed_projects", counter_data.to_json)

      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.closed_projects_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "closed_projects_by_dates")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      ids = closed_projects(
        current_access, current_user, current_profile, current_agency,
        nil,
        initial_date: initial_date, final_date: final_date, agency_ids: agency_ids, expire_key: expire_key
      )
      counter_data = Project.where(id: ids).sizes_by_dates(:project_end, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "closed_projects_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.rejected_projects(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil,projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "rejected_projects")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      projects = filter_projects_by_agency(projects, agency_ids) if projects
      if initial_date.present? && final_date.present?
        counter_data = projects ? projects.projects_in_range(initial_date, final_date, 'project_end').on_not_deferrer.ids : Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).projects_in_range(initial_date, final_date, 'project_end').on_not_deferrer.ids
      else
        counter_data = projects ? projects.on_not_deferrer.ids : Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).on_not_deferrer.ids
      end
      $redis.hset(counter_key, "rejected_projects", counter_data.to_json)

      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.rejected_projects_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "rejected_projects_by_dates")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      ids = rejected_projects(
        current_access, current_user, current_profile, current_agency,
        nil,
        initial_date: initial_date, final_date: final_date, agency_ids: agency_ids, expire_key: expire_key
      )
      counter_data = Project.where(id: ids).sizes_by_dates(:project_end, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "rejected_projects_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.project_completed(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil,projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "project_completed")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      projects = filter_projects_by_agency(projects, agency_ids) if projects
      if initial_date.present? && final_date.present?
        counter_data = projects ? projects.projects_in_range(final_date, 'project_end').completed_and_closed.ids : Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).where.not(status_type_id:1).from_friday_to_friday(:project_end, initial_date: initial_date).completed_and_closed.ids
      else
        counter_data = projects ? projects.completed_and_closed.ids : Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).where.not(status_type_id:1).from_friday_to_friday(:project_end).completed_and_closed.ids
      end
      #counter_data = projects ? projects.completed_and_closed.ids : Project.where(id: projects_from_friday_to_friday(current_access, current_user, current_profile, current_agency)).completed_and_closed.ids
      $redis.hset(counter_key, "project_completed", counter_data.to_json)

      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end
  def self.get_histories_project_completed(project_ids = nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(nil, nil, nil, nil, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "flow_histories_completed")
    if counter_data
      flow_history = FlowHistory.joins(:project, project: [:service, service: [:flow_status]]).where(id: JSON.parse(counter_data,symbolize_names: true))
    else
      flow_history = FlowHistory.joins(:project, project: [:service, service: [:flow_status]]).from_friday_to_friday(:created_at, initial_date: initial_date)
        .where.not(project_id: project_ids)
        .where("flow_histories.status_type_id IN (#{Project::COMPLETED.join(',')}) AND projects.status_type_id NOT IN (#{Project::COMPLETED.join(',')}) AND flow_histories.flow_id = flow_statuses.flow_id").distinct
      counter_data =  flow_history.ids
      $redis.hset(counter_key, "flow_histories_completed", counter_data.to_json)

      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    flow_history = flow_history.where(projects: { agency_id: agency_ids }) if agency_ids.present?
    flow_history.separate_by_agency_and_status_types
  end

  def self.project_completed_by_agency_and_status_types(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "project_completed_by_agency_and_status_types")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      completed_ids = project_completed(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      histories_completed = get_histories_project_completed(completed_ids, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      counter_data = Project.where(id: completed_ids).separate_by_agency_and_status_types
      if counter_data.present? && histories_completed.present?
        histories_completed.each_with_index do |(key,data_value),index|
          if counter_data[key].present?
            data_value.each_with_index do |(key2,data_value2),index2|
              if counter_data[key][key2].present?
                counter_data[key][key2] = (counter_data[key][key2].to_i + data_value2.to_i)
              else
                counter_data[key].merge!(key2.to_s => data_value2)
              end
            end
          else
            counter_data.merge!(key.to_s => data_value)
          end
        end
      elsif !counter_data.present? && histories_completed.present?
        counter_data = histories_completed
      end

      $redis.hset(counter_key, "project_completed_by_agency_and_status_types", counter_data.to_json)

      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.total_fiscal(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "total_fiscal")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      fiscal_service_ids = Service.joins(:service_type).where("service_types.name LIKE ?", "%Ação Fiscal%").pluck(:id)

      scope = if projects
        filter_projects_by_agency(projects, agency_ids).where(service_id: fiscal_service_ids)
      else
        Project.where(id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)).fiscal_actions
      end

      if initial_date.present? && final_date.present?
        scope = scope.projects_in_range(initial_date, final_date, 'project_start')
      end

      counter_data = scope.ids
      $redis.hset(counter_key, "total_fiscal", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.total_fiscal_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "total_fiscal_by_dates")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      ids = total_fiscal(
        current_access, current_user, current_profile, current_agency,
        nil,
        initial_date: initial_date, final_date: final_date, agency_ids: agency_ids, expire_key: expire_key
      )
      counter_data = Project.where(id: ids).sizes_by_dates(:updated_at, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "total_fiscal_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.total_notification(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "total_notification")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      scope =
        if projects
          filter_projects_by_agency(projects, agency_ids).where(service_id: [38, 32, 30, 26, 25, 22])
        else
          Project.where(
            id: project_ids(
              current_access, current_user, current_profile, current_agency,
              initial_date: initial_date, final_date: final_date, agency_ids: agency_ids
            )
          ).notifications
        end

      if initial_date.present? && final_date.present?
        scope = scope.projects_in_range(initial_date, final_date, 'project_start')
      end

      counter_data = scope.distinct.ids
      $redis.hset(counter_key, "total_notification", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.total_notification_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "total_notification_by_dates")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      ids = total_notification(
        current_access, current_user, current_profile, current_agency, nil,
        initial_date: initial_date, final_date: final_date, agency_ids: agency_ids, expire_key: expire_key
      )
      counter_data = Project.where(id: ids).sizes_by_dates(:updated_at, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "total_notification_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.reports(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "reports")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      base_project_ids = if projects
        filter_projects_by_agency(projects, agency_ids).ids
      else
        project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      end

      scope = Report.where(project_id: base_project_ids)

      if initial_date.present? && final_date.present?
        start_at = Time.zone.parse("#{initial_date} 00:00:00")
        end_at   = Time.zone.parse("#{final_date} 23:59:59")
        scope = scope.where(created_at: start_at..end_at)
      end

      counter_data = scope.ids
      $redis.hset(counter_key, "reports", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end


  def self.report_additionals_to_requester(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "report_additionals_to_requester")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      base = if projects
        ReportAdditional.where(project_id: filter_projects_by_agency(projects, agency_ids).ids)
      else
        ReportAdditional.where(project_id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids))
      end

      if initial_date.present? && final_date.present?
        start_at = Time.zone.parse("#{initial_date} 00:00:00")
        end_at   = Time.zone.parse("#{final_date} 23:59:59")
        counter_data = base.to_requester.where(created_at: start_at..end_at).ids
      else
        counter_data = base.to_requester.ids
      end

      $redis.hset(counter_key, "report_additionals_to_requester", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.report_additionals_to_requester_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "report_additionals_to_requester_by_dates")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      ids = report_additionals_to_requester(
        current_access, current_user, current_profile, current_agency, nil,
        initial_date: initial_date, final_date: final_date, agency_ids: agency_ids, expire_key: expire_key
      )
      counter_data = ReportAdditional.where(id: ids).sizes_by_dates(:created_at, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "report_additionals_to_requester_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.report_additionals_to_profile(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, projects=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "report_additionals_to_profile")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      base = if projects
        ReportAdditional.where(project_id: filter_projects_by_agency(projects, agency_ids).ids)
      else
        ReportAdditional.where(project_id: project_ids(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids))
      end

      if initial_date.present? && final_date.present?
        start_at = Time.zone.parse("#{initial_date} 00:00:00")
        end_at   = Time.zone.parse("#{final_date} 23:59:59")
        counter_data = base.to_profile.where(created_at: start_at..end_at).ids
      else
        counter_data = base.to_profile.ids
      end

      $redis.hset(counter_key, "report_additionals_to_profile", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.report_additionals_to_profile_by_dates(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "report_additionals_to_profile_by_dates")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      ids = report_additionals_to_profile(
        current_access, current_user, current_profile, current_agency, nil,
        initial_date: initial_date, final_date: final_date, agency_ids: agency_ids, expire_key: expire_key
      )
      counter_data = ReportAdditional.where(id: ids).sizes_by_dates(:created_at, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "report_additionals_to_profile_by_dates", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end
    counter_data
  end

  def self.all_users(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "all_users")

    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      if initial_date.present? && final_date.present?
        start_date = Time.parse(initial_date).beginning_of_day
        end_date = Time.parse(final_date).end_of_day
        counter_data = User.where(created_at: start_date..end_date).ids
      elsif final_date.present?
        counter_data = User.where('users.created_at <= ?', Time.parse(final_date).end_of_day).ids
      else
        counter_data = User.all.ids
      end

      $redis.hset(counter_key, "all_users", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end

    counter_data
  end

  def self.active_users(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "active_users")

    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      if initial_date.present? && final_date.present?
        start_date = Time.parse(initial_date).beginning_of_day
        end_date = Time.parse(final_date).end_of_day
        counter_data = User.active.where(created_at: start_date..end_date).ids
      elsif final_date.present?
        counter_data = User.active.where('users.created_at <= ?', Time.parse(final_date).end_of_day).ids
      else
        counter_data = User.active.ids
      end

      $redis.hset(counter_key, "active_users", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end

    counter_data
  end

  def self.inactive_users(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "inactive_users")

    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      if initial_date.present? && final_date.present?
        start_date = Time.parse(initial_date).beginning_of_day
        end_date = Time.parse(final_date).end_of_day
        counter_data = User.inactive.where(created_at: start_date..end_date).ids
      elsif final_date.present?
        counter_data = User.inactive.where('users.created_at <= ?', Time.parse(final_date).end_of_day).ids
      else
        counter_data = User.inactive.ids
      end

      $redis.hset(counter_key, "inactive_users", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end

    counter_data
  end

  def self.blocked_users(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "blocked_users")

    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      if initial_date.present? && final_date.present?
        start_date = Time.parse(initial_date).beginning_of_day
        end_date = Time.parse(final_date).end_of_day
        counter_data = User.blocked.where(created_at: start_date..end_date).ids
      elsif final_date.present?
        counter_data = User.blocked.where('users.created_at <= ?', Time.parse(final_date).end_of_day).ids
      else
        counter_data = User.blocked.ids
      end

      $redis.hset(counter_key, "blocked_users", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end

    counter_data
  end

  def self.users_by_type(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "users_by_type")

    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      counter_data =
        if initial_date.present? && final_date.present?
          User.sizes_by_type_with_date(initial_date, final_date)
        else
          User.sizes_by_type
        end

      $redis.hset(counter_key, "users_by_type", counter_data.to_json)
      $redis.expire(counter_key, 1.hour) if expire_key || (initial_date.present? && final_date.present?)
    end

    counter_data
  end

  def self.completed_and_sent_of_the_year(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "completed_and_sent_of_the_year")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Project.completed_and_sent_of_the_year(initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "completed_and_sent_of_the_year", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.deferred_projects_with_agency_of_the_year(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "deferred_projects_with_agency_of_the_year")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Project.deferred_projects_with_agency_of_the_year(initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
      $redis.hset(counter_key, "deferred_projects_with_agency_of_the_year", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end
  def self.projects_separated_by_name_and_year(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "projects_separated_by_name_and_year")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Project.projects_separated_by_name_and_year(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "projects_separated_by_name_and_year", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end
  def self.get_status_for_charts_dashboard(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "get_status_for_charts_dashboard")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Project.get_status_for_charts_dashboard(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "get_status_for_charts_dashboard", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end
  def self.projects_separated_by_building_purpose(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "projects_separated_by_building_purpose")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Project.projects_separated_by_building_purpose(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "projects_separated_by_building_purpose", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end
  def self.process_separated_by_technical_analysis(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "process_separated_by_technical_analysis")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Report.process_separated_by_technical_analysis(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "process_separated_by_technical_analysis", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end
  def self.projects_separated_by_building_kind(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "projects_separated_by_building_kind")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Project.projects_separated_by_building_kind(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "projects_separated_by_building_kind", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.project_layout_monitor_sum_work_total_area(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "project_layout_monitor_sum_work_total_area")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Project.project_layout_monitor_sum_work_total_area(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "project_layout_monitor_sum_work_total_area", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.project_layout_monitor_sum_quantity_of_units(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "project_layout_monitor_sum_quantity_of_units")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = Project.project_layout_monitor_sum_quantity_of_units(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "project_layout_monitor_sum_quantity_of_units", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.data_for_the_treasury_chart(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "data_for_the_treasury_chart")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = ReportTributary.data_for_the_treasury_chart(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "data_for_the_treasury_chart", counter_data.to_json)
      #$redis.expire(counter_key, 1.hour)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.data_for_the_treasury_chart_for_agency(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "data_for_the_treasury_chart_for_agency")
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      # Don't pass agency_ids - ReportTributary doesn't support it yet
      counter_data = ReportTributary.data_for_the_treasury_chart_for_agency(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "data_for_the_treasury_chart_for_agency", counter_data.to_json)
      if expire_key || (initial_date.present? && final_date.present?)
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.tributary_separated_by_agency_and_year(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "tributary_separated_by_agency_and_year")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = ReportTributary.tributary_separated_by_agency_and_year(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "tributary_separated_by_agency_and_year", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.get_status_rates_for_charting_dashboard(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "get_status_rates_for_charting_dashboard")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = ReportTributary.get_status_rates_for_charting_dashboard(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "get_status_rates_for_charting_dashboard", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end
  def self.rates_separated_by_building_purpose(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "rates_separated_by_building_purpose")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = ReportTributary.rates_separated_by_building_purpose(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "rates_separated_by_building_purpose", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.rates_separated_by_building_kind(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "rates_separated_by_building_kind")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = ReportTributary.rates_separated_by_building_kind(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "rates_separated_by_building_kind", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.rates_separated_by_technical_analysis(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "rates_separated_by_technical_analysis")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = ReportTributary.rates_separated_by_technical_analysis(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "rates_separated_by_technical_analysis", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end
  def self.get_annual_revenue_chart(current_access=nil, current_user=nil, current_profile=nil, current_agency=nil, initial_date: nil, final_date: nil, agency_ids: nil, expire_key: false)
    counter_key = get_key(current_access, current_user, current_profile, current_agency, initial_date: initial_date, final_date: final_date, agency_ids: agency_ids)
    counter_data = $redis.hget(counter_key, "get_annual_revenue_chart")
    if counter_data
      counter_data = JSON.parse(counter_data,symbolize_names: true)
    else
      counter_data = ReportTributary.get_annual_revenue_chart(initial_date: initial_date, final_date: final_date)
      $redis.hset(counter_key, "get_annual_revenue_chart", counter_data.to_json)
      if expire_key || initial_date.present? && final_date.present?
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.get_key current_access, current_user, current_profile, current_agency, initial_date: nil, final_date: nil, agency_ids: nil
    key =
      if initial_date.present? && final_date.present?
        "user:#{initial_date.to_s.gsub('-','').gsub("/",'')}:#{final_date.to_s.gsub('-','').gsub("/",'')}"
      elsif current_user.present?
        "user:#{current_user.id}:#{current_access.id}:#{current_agency.id if current_agency.present?}:#{current_profile.id if current_profile.present?}:main_counters"
      else
        "user:general:main_counters"
      end

    agency_ids.present? ? "#{key}:agencies:#{Array(agency_ids).map(&:to_i).sort.join('-')}" : key
  end

  def self.dashboard_panel(current_access = nil, current_user = nil, current_profile = nil, current_agency = nil)
    counter_key = get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, 'dashboard_panel')
    if counter_data && counter_data.include?('counter_sum_7')
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    elsif ProjectLayout.count > 0 #&& ProjectToMonitorWorkDimension.count > 0
      sel = ''
      Counter.includes(:services, :status_types, :number_kind).each do |counter|
        m = [1, 4].include?(counter.id) ? 'sum(' : 'count(distinct'
        c = 'projects.id'
        c = 'project_layouts.total_of_the_work' if counter.id == 1
        if counter.id == 4
          c = """
          ifnull(nullif(project_to_monitor_work_dimensions.total_of_the_work_confirmed, 0)
          , ifnull(nullif(project_to_monitor_work_dimensions.total_of_the_work_required, 0)
          , ifnull(nullif(project_to_monitor_work_dimensions.demolition_confirmed, 0)
          , ifnull(nullif(project_to_monitor_work_dimensions.demolition_required, 0)
          , ifnull(nullif(project_to_monitor_work_dimensions.work_total_area_confirmed, 0)
          , ifnull(nullif(project_to_monitor_work_dimensions.work_total_area_required, 0)
          , ifnull(nullif(project_layouts.total_of_the_work, 0)
          , ifnull(nullif(project_layouts.demolition, 0)
          , ifnull(nullif(project_layouts.work_total_area, 0)
          , 0)))))))))"""
        end
        sel += "#{m}(if(projects.service_id IN (#{counter.services.ids.join(',')}) && projects.status_type_id IN (#{counter.status_types.ids.join(',')}), #{c}, null))) AS counter_sum_#{counter.id}, "
        sel += "'#{counter.number_kind.name}' AS counter_name_#{counter.id}, "
      end
      sel += "count(distinct(if(projects.status_type_id IN (#{Project::COMPLETED.join(',')}), projects.id, null))) AS counter_sum_5, "
      sel += "'Processos Concluídos' counter_name_5, 0 AS counter_sum_6, 'Usuários Ativos' counter_name_6, 0 AS counter_sum_7, 'Arquivos Anexos' counter_name_7"

      counter_data = Project.left_outer_joins(:project_layout, :project_to_monitor_work_dimension).select(sel).first
      counter_data[:counter_sum_6] = User.where(active: true).count
      counter_data[:counter_sum_7] = ProjectUpload.count

      $redis.hset(counter_key, 'dashboard_panel', counter_data.to_json)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

  def self.dashboard_cards(projects, current_access = nil, current_user = nil, current_profile = nil, current_agency = nil, redis)
    counter_key = get_key(current_access, current_user, current_profile, current_agency)
    counter_data = $redis.hget(counter_key, 'dashboard_cards')
    if counter_data && redis
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      d = Date.today
      between = {}
      between[:this_day] = "BETWEEN '#{d.beginning_of_day}' AND '#{d.end_of_day}'"
      between[:this_week] = "BETWEEN '#{d.beginning_of_week}' AND '#{d.end_of_week}'"
      between[:this_month] = "BETWEEN '#{d.beginning_of_month}' AND '#{d.end_of_month}'"
      between[:this_year] = "BETWEEN '#{d.beginning_of_year}' AND '#{d.end_of_year}'"
      between[:last_day] = "BETWEEN '#{d.beginning_of_day - 1.day}' AND '#{d.end_of_day - 1.day}'"
      between[:seven_days_before] = "BETWEEN '#{d - 7.days}' AND '#{d}'"
      between[:thirty_days_before] = "BETWEEN '#{d - 30.days}' AND '#{d}'"
      between[:year_less_one] = "BETWEEN '#{(d - 1.year).beginning_of_year}' AND '#{(d - 1.year).end_of_year}'"
      between[:year_less_two] = "BETWEEN '#{(d - 2.years).beginning_of_year}' AND '#{(d - 2.years).end_of_year}'"
      between[:year_less_three] = "BETWEEN '#{(d - 3.years).beginning_of_year}' AND '#{(d - 3.years).end_of_year}'"
      between[:year_less_four] = "BETWEEN '#{(d - 4.years).beginning_of_year}' AND '#{(d - 4.years).end_of_year}'"

      # Processos Concluídos e Serviços
      status = {}
      status[:atualizacao] = 'true'
      status[:deferido] = 'projects.status_type_id IN (6, 7)'
      status[:indeferido] = 'projects.status_type_id = 8'
      status[:encerrado] = 'projects.status_type_id = 9'
      status[:concluido] = 'projects.status_type_id IN (6, 7, 8, 9)'
      status[:lancado] = 'projects.status_type_id IN (26, 27)'
      status[:arquivado] = 'projects.status_type_id = 15'
      status[:cancelado] = 'projects.status_type_id = 12'
      status[:vencido] = 'projects.status_type_id = 24'

      sel = ''
      sel += "'Deferidos' AS status_deferido, "
      sel += "'Indeferidos' AS status_indeferido, "
      sel += "'Encerrados' AS status_encerrado, "
      sel += "'Concluídos' AS status_concluido, "
      sel += "'Cancelados' AS status_cancelado, "
      sel += "'Vencidos' AS status_vencido, "
      sel += "'Atualizações de Processo' AS status_atualizacao, "
      sel += "'Lançados' AS status_lancado, "
      sel += "'Arquivados' AS status_arquivado, "

      ['updated_at', 'project_end'].each do |c|
        status.keys.each do |s|
          between.keys.each do |b|
            sel += "sum(if(ifnull(projects.#{c}, projects.updated_at) #{between[b]} && #{status[s]}, 1, 0)) AS #{s}_#{c}_#{b}, "
          end
        end
      end
      between.keys.each do |b|
        sel += "sum(if(projects.updated_at #{between[b]}, 1, 0)) AS total_#{b}, "
      end
      status.keys.each do |s|
        sel += "sum(if(#{status[s]}, 1, 0)) AS total_#{s}, "
      end
      sel += 'sum(1) AS total'

      d1 = projects.select(sel).first

      # Processos em Tramitação
      ids = StatusType.ids
      status = {}
      status[:conferir_documento] = 'reports.status_type_id = 2' if ids.include? 2
      status[:analise_tributaria] = 'reports.status_type_id = 10' if ids.include? 10
      status[:aguardando_pagamento] = 'reports.status_type_id = 11' if ids.include? 11
      status[:analise_tecnica] = 'reports.status_type_id = 3' if ids.include? 3
      status[:redacao_final] = 'reports.status_type_id = 4' if ids.include? 4
      status[:deferimento] = 'reports.status_type_id = 5' if ids.include? 5
      status[:fiscalizacao] = 'reports.status_type_id = 31' if ids.include? 31
      status[:numeracao] = 'reports.status_type_id = 32' if ids.include? 32
      status[:certificacao] = 'reports.status_type_id = 36' if ids.include? 36
      status[:cadastro_imobiliario] = 'reports.status_type_id = 39' if ids.include? 39
      status[:tecnica_fiscalizacao] = 'reports.status_type_id = 44' if ids.include? 44
      status[:outros] = 'reports.status_type_id not in (2, 10, 11, 3, 4, 5, 31, 32, 36, 39, 44)'

      sel = ''
      StatusType.where(id: [2, 10, 11, 3, 4, 5, 31, 32, 36, 39, 44]).each do |e|
        sel += "'#{e.name}' AS status_conferir_documento, " if e.id == 2
        sel += "'#{e.name}' AS status_analise_tributaria, " if e.id == 10
        sel += "'#{e.name}' AS status_aguardando_pagamento, " if e.id == 11
        sel += "'#{e.name}' AS status_analise_tecnica, " if e.id == 3
        sel += "'#{e.name}' AS status_redacao_final, " if e.id == 4
        sel += "'#{e.name}' AS status_deferimento, " if e.id == 5
        sel += "'#{e.name}' AS status_fiscalizacao, " if e.id == 31
        sel += "'#{e.name}' AS status_numeracao, " if e.id == 32
        sel += "'#{e.name}' AS status_certificacao, " if e.id == 36
        sel += "'#{e.name}' AS status_cadastro_imobiliario, " if e.id == 39
        sel += "'#{e.name}' AS status_tecnica_fiscalizacao, " if e.id == 44
      end
      sel += "'Outros' AS status_outros, "

      status.keys.each do |s|
        between.keys.each do |b|
          sel += "sum(if(reports.created_at #{between[b]} && #{status[s]}, 1, 0)) AS #{s}_created_at_#{b}, "
        end
        sel += "sum(if(#{status[s]}, 1, 0)) AS total_#{s}, "
      end

      d2 = Report.where(project_id: projects.ids).select(sel.delete_suffix(', ')).first

      # salvar no redis
      counter_data = JSON.parse(d2.to_json, symbolize_names: true).merge(JSON.parse(d1.to_json, symbolize_names: true))
      if redis
        $redis.hset(counter_key, 'dashboard_cards', counter_data.to_json)
        $redis.expire(counter_key, 1.hour)
      end
    end
    counter_data
  end

  def self.purpose_kind(current_access = nil, current_user = nil, current_profile = nil, current_agency = nil, y)
    if y == 'year_less_one'
      projects = Project.year_less_one
      yy = (Time.zone.now - 1.year).strftime('%Y')
    elsif y == 'year_less_two'
      projects = Project.year_less_two
      yy = (Time.zone.now - 2.year).strftime('%Y')
    elsif y == 'year_less_three'
      projects = Project.year_less_three
      yy = (Time.zone.now - 3.year).strftime('%Y')
    elsif y == 'year_less_four'
      projects = Project.year_less_four
      yy = (Time.zone.now - 4.year).strftime('%Y')
    else
      projects = Project.year_now
      yy = Time.zone.now.strftime('%Y')
    end

    counter_key = get_key(current_access, current_user, current_profile, current_agency) + '_' + yy
    counter_data = $redis.hget(counter_key, 'purpose_kind')
    if counter_data
      counter_data = JSON.parse(counter_data, symbolize_names: true)
    else
      sel = yy + ' as ano'
      sel += ', building_purposes.name as purpose'
      sel += ', building_kinds.name as kind'
      sel += ', count(*) as counted'
      sel += ''', sum(ifnull(nullif(project_to_monitor_work_dimensions.total_of_the_work_confirmed, 0)
        , ifnull(nullif(project_to_monitor_work_dimensions.total_of_the_work_required, 0)
        , ifnull(nullif(project_to_monitor_work_dimensions.demolition_confirmed, 0)
        , ifnull(nullif(project_to_monitor_work_dimensions.demolition_required, 0)
        , ifnull(nullif(project_to_monitor_work_dimensions.work_total_area_confirmed, 0)
        , ifnull(nullif(project_to_monitor_work_dimensions.work_total_area_required, 0)
        , ifnull(nullif(project_layouts.total_of_the_work, 0)
        , ifnull(nullif(project_layouts.demolition, 0)
        , ifnull(nullif(project_layouts.work_total_area, 0)
        , 0)))))))))) as area'''
      counter = Counter.find_by(id: 4)
      counter_data = projects
        .left_joins(:building_purpose, :building_kind, :project_to_monitor_work_dimension, :project_layout)
        .where(service_id: counter.services.ids, status_type_id: counter.status_types.ids)
        .group('building_purposes.name, building_kinds.name')
        .select(sel)
        .order('purpose, kind')

      counter_data = JSON.parse(counter_data.to_json, symbolize_names: true)
      $redis.hset(counter_key, 'purpose_kind', counter_data.to_json)
      $redis.expire(counter_key, 1.hour)
    end
    counter_data
  end

end

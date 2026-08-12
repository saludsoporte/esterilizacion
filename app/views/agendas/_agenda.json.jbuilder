json.extract! agenda, :id, :fecha, :medico, :citas, :hora_inicio, :activo, :created_at, :updated_at
json.url agenda_url(agenda, format: :json)

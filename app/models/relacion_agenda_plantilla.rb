class RelacionAgendaPlantilla < ApplicationRecord
  belongs_to :agenda
  belongs_to :plantilla
  belongs_to :user
  belongs_to :detalle_plantilla

  def horarios    
    detalle = DetallePlantilla.find(self.detalle_plantilla_id)
    horarios = detalle.mesa.detalle_mesas.map { |detalle_mesa| detalle_mesa.detalle_hora } 
    return horarios 
  end  

  def dia_cita
    self.dia_nombre+" "+self.dia.to_s+" - "+mes.to_s
  end
  def mes
    fecha_inicio = self.agenda.fecha_inicio
    fecha_fin = self.agenda.fecha_fin
    logger.debug("*********** INI #{fecha_inicio}****")
    logger.debug("*********** FIN #{fecha_fin}****")
    begin
      fecha_aux_i = fecha_inicio.change(day:self.dia)
    rescue
      if fecha_inicio.month == 2 #si es febrero
        fecha_aux_i = fecha_inicio.change(day:28)  
      else #si el mes tiene 30 dias
        fecha_aux_i = fecha_inicio.change(day:self.dia-1)  
      end      
    end
    begin
      fecha_aux_f = fecha_fin.change(day:self.dia)
    rescue
      if fecha_inicio.month == 2 #si es febrero
        fecha_aux_f = fecha_fin.change(day:28)
      else #si el mes tiene 30 dias
        fecha_aux_f = fecha_fin.change(day:self.dia - 1 )
      end
    end    
    logger.debug("*********** #{fecha_aux_i}****")
    logger.debug("*********** #{fecha_aux_f}****")
  
    logger.debug("*********** #{fecha_aux_i.day >= fecha_inicio.day && fecha_aux_i < fecha_fin ? true : false }****")
    logger.debug("*********** #{fecha_aux_i.day > fecha_inicio.day && fecha_aux_i.day < fecha_fin.day ? true : false }****")
    if fecha_inicio.month == fecha_fin.month      
      return select_mes(fecha_inicio.month)
    elsif fecha_aux_i.day >= fecha_inicio.day && fecha_aux_i < fecha_fin
      return select_mes(fecha_inicio.month)
    elsif fecha_aux_i.day > fecha_inicio.day && fecha_aux_i.day < fecha_fin.day
      return select_mes(fecha_inicio.month)
    elsif fecha_aux_i.day > fecha_fin.day && fecha_inicio < fecha_fin      
      return select_mes(fecha_fin.month)
    else      
      return select_mes(fecha_fin.month)
    end    
  end
  def select_mes(mes)
    return case mes
    when 1
      "Enero"
    when 2
      "Febrero"
    when 3
      "Marzo"
    when 4
      "Abril"
    when 5
      "Mayo"
    when 6
      "Junio"
    when 7
      "Julio"
    when 8
      "Agosto"
    when 9
      "Septiembre"
    when 10
      "Octubre"
    when 11
      "Noviembre"
    when 12
      "Diciembre"
    end    
  end
end

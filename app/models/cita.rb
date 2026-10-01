class Cita < ApplicationRecord
  belongs_to :relacion_agenda_plantilla,optional: true
  belongs_to :detalle_mesa,optional: true
  belongs_to :agenda

  validates :relacion_agenda_plantilla_id, 
            presence: { message: "Debe escoger un dia para la cita"}
  validates :detalle_mesa_id,
            presence: { message: "Debe escoger un horario para la cita"}

  validates :nombre_dueño,
            presence: {message: "Nombre del dueño no puede estar vacio"}  
  validates :nombre_mascota, 
            presence: {message: "Nombre de la mascota no puede estar vacio"}
  validates :raza, presence: {message: "Raza no puede estar vacio"}

  validates :edad_mascota,
            presence: {message: "La edad de la mascota no puede estar vacio"},
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
          allow_blank: true
            

  validates :telefono,
            presence: {message: "El telefono introducido no es valido"},
            format: {
              with: /\A\d{10}\z/,
              message: "debe tener exactamente 10 dígitos"
            },
          allow_blank: true



  validates :curp,
            presence: {message: "El CURP introducido no es valido"},
            length: {
              is: 18
            },
            format: {
              with: /\A[A-Z0-9]{18}\z/,
              message: "debe tener 18 caracteres y utilizar solamente letras y números"
            },
          allow_blank: true
            

  def sexo_definido
    self[:sexo_dueño] == 'M' ? 'Masculino' : 'Femenino'
  end
  def nombre_completo
    self.nombre_dueño+" "+self.apellido_p_dueño+" "+self.apellido_m_dueño
  end
  def especie_y_sexo
    self.especie+" | "+self.sexo
  end
  def horarios
    self.detalle_mesa.horario.strftime("%H:%M")+" - "+self.relacion_agenda_plantilla.dia_nombre+" "+self.relacion_agenda_plantilla.dia.to_s
  end
end

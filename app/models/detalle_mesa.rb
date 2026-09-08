class DetalleMesa < ApplicationRecord
  belongs_to :mesa
  validates :paciente, presence: true
  validates :sexo, presence: true
  validates :horario,
            uniqueness: {
              scope: :mesa_id,
              message: "ya está ocupado en esta mesa"
            }
  def detalle_hora
    self.paciente+self.sexo+" - "+self.horario.strftime("%H:%M")
  end
end

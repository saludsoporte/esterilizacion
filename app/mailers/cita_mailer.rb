class CitaMailer < ApplicationMailer
  def confirmacion
    @cita = params[:cita]

    mail(
      to: @cita.email,
      subject: "Confirmación de cita - Esterilización Canina y Felina"
    )
  end
end

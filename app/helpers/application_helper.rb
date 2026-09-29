module ApplicationHelper
  include Pagy::Frontend
  def pagy_info(pagy)
    if pagy.count.zero?
      "No se encontraron elementos"
    elsif pagy.pages == 1
      "Mostrando #{pagy.count} #{pagy.count == 1 ? 'elemento' : 'elementos'}"
    else
      "Mostrando #{pagy.from}-#{pagy.to} de #{pagy.count} elementos"
    end
  end
end

require "test_helper"

class NotificacionesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get notificaciones_index_url
    assert_response :success
  end
end

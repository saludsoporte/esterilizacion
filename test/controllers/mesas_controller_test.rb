require "test_helper"

class MesasControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mesas_new_url
    assert_response :success
  end
end

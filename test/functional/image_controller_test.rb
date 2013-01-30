require 'test_helper'

class ImageControllerTest < ActionController::TestCase
  test "should get proxy" do
    get :proxy
    assert_response :success
  end

end

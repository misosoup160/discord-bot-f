require "test_helper"

class Users::AnswersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_answers_index_url
    assert_response :success
  end
end

require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end
=begin
  test "current_user returns right user when session is nil" do
    puts "user remember_digest - #{@user.remember_digest}"
    assert_equal @user, current_user
    assert is_logged_in?
  end
=end


  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
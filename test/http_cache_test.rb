require 'test_helper'

class HttpCacheResponderTest < ActionController::TestCase
  tests UsersController
  
  def setup
    @request.accept = "application/xml"
    ActionController::Base.perform_caching = true
    
    User.create(:name => "First", :updated_at => Time.utc(2009))
    User.create(:name => "Second", :updated_at => Time.utc(2008))
  end
  
  def test_responds_with_last_modified_using_the_latest_timestamp
    get :index
    assert_equal(Time.utc(2009).httpdate, @response.headers["Last-Modified"])
    assert_match('<?xml version="1.0" encoding="UTF-8"?>', @response.body)
    assert_equal(200, @response.status)
  end
  
  def test_returns_not_modified_if_request_is_still_fresh
    @request.env["HTTP_IF_MODIFIED_SINCE"] = Time.utc(2009, 6).httpdate
    get :index
    assert_equal(304, @response.status)
    assert @response.body.blank?
  end
  
  def test_returns_ok_with_last_modified_if_request_is_not_fresh
    @request.env["HTTP_IF_MODIFIED_SINCE"] = Time.utc(2008, 6).httpdate
    get :index
    assert_equal(Time.utc(2009).httpdate, @response.headers["Last-Modified"])
    assert_match('<?xml version="1.0" encoding="UTF-8"?>', @response.body)
    assert_equal(200, @response.status)
  end
end
require 'test_helper'

class NavigationTest < ActiveSupport::IntegrationCase
  test "sets flash messages automatically" do
    visit "/users"
    
    click_link "New User"
    fill_in "Name", :with => "John Doe"
    click_button "Create User"
    
    assert has_content?("User was successfully created."), "Expected to show flash message on create"
    
    click_link "Edit"
    fill_in "Name", :with => "Doe, John"
    click_button "Update User"
    
    assert has_content?("User was successfully updated."), "Expected to show flash message on update"
    
    click_link "Back"
    click_link "Destroy"
    
    assert has_content?("User was successfully destroyed."), "Expected to show flash message on destroy"
  end
end

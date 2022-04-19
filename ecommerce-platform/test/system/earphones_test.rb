require "application_system_test_case"

class EarphonesTest < ApplicationSystemTestCase
  setup do
    @earphone = earphones(:one)
  end

  test "visiting the index" do
    visit earphones_url
    assert_selector "h1", text: "Earphones"
  end

  test "creating a Earphone" do
    visit earphones_url
    click_on "New Earphone"

    fill_in "Image", with: @earphone.image
    fill_in "Price", with: @earphone.price
    fill_in "Title", with: @earphone.title
    click_on "Create Earphone"

    assert_text "Earphone was successfully created"
    click_on "Back"
  end

  test "updating a Earphone" do
    visit earphones_url
    click_on "Edit", match: :first

    fill_in "Image", with: @earphone.image
    fill_in "Price", with: @earphone.price
    fill_in "Title", with: @earphone.title
    click_on "Update Earphone"

    assert_text "Earphone was successfully updated"
    click_on "Back"
  end

  test "destroying a Earphone" do
    visit earphones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Earphone was successfully destroyed"
  end
end

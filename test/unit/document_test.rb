require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    @document = Document.new
    User.stamper = User.first
  end

  test "should not save document without document file, title, language and accepting scribd_terms" do
    assert_equal @document.save, false
    assert_not_nil @document.errors[:document_file_name]
    assert_not_nil @document.errors[:title]
    assert_not_nil @document.errors[:language]
    assert_not_nil @document.errors[:accept_scribd_terms]
    assert_equal @document.errors.length, 4
  end

end

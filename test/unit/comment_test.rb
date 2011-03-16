require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @comment = Comment.new
    User.stamper = User.first
  end
  
  test "should not save comment without content" do
    assert_equal @comment.save, false
    assert_not_nil @comment.errors[:comment]
  end

  test "should not save comment without commentable" do
    assert_equal @comment.save, false
    assert_not_nil @comment.errors[:commentable]
  end

  test "valid comment have content and commentable" do
    @comment.comment = "Comment content"
    @comment.commentable = Video.first
    assert @comment.save
    assert @comment.errors.empty?
  end
end

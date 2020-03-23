class AddUpvoteAndDownvoteToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :upvote, :integer
    add_column :reviews, :downvote, :integer
  end
end

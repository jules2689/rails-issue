# frozen_string_literal: true

begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "rails", github: "rails/rails"
  gem "pg"
end

require "active_record"
require "minitest/autorun"
require "logger"

# This connection will do for database-independent bug reports.
db_config = { adapter: "postgresql", database: "rails_issue", username: "postgres" }
ActiveRecord::Base.establish_connection(db_config.merge(database: nil))
ActiveRecord::Base.connection.create_database(db_config[:database]) rescue nil
ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
  end

  create_table :comments, force: true do |t|
    t.integer :post_id
    t.boolean :published
  end
end

class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class BugTest < Minitest::Test
  def setup
    super
    @post = Post.create
    @comment = Comment.create(post: @post, published: true)
  end

  # These all work

  def test_works_when_using_boolean_value
    as_bool = @post.comments.all.where(published: true)
    assert_equal 1, as_bool.count
    assert as_bool.all?(&:published), 'All the my values were not true' 
  end

  def test_works_when_using_string
    as_string = @post.comments.all.where(published: 'true')
    assert_equal 1, as_string.count
    assert as_string.all?(&:published), 'All the my values were not true' 
  end

  def test_true_string_is_evaluated_to_true
    Comment.all.each { |m| m.update(published: false) }

    as_string = @post.comments.all.where(published: 'true')
    assert_equal 0, as_string.count, 'true string is evaluated to false :('
  end
end
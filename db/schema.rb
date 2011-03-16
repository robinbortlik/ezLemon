# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110208195030) do

  create_table "activities", :force => true do |t|
    t.integer  "actor_id",     :null => false
    t.integer  "subject_id",   :null => false
    t.integer  "target_id"
    t.string   "subject_type", :null => false
    t.string   "action",       :null => false
    t.datetime "created_at",   :null => false
  end

  add_index "activities", ["actor_id"], :name => "index_activities_on_actor_id"
  add_index "activities", ["subject_id", "subject_type"], :name => "index_activities_on_subject_id_and_subject_type"
  add_index "activities", ["target_id"], :name => "index_activities_on_target_id"

  create_table "comments", :force => true do |t|
    t.text     "comment",          :null => false
    t.integer  "commentable_id",   :null => false
    t.string   "commentable_type", :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["creator_id"], :name => "index_comments_on_creator_id"

  create_table "documents", :force => true do |t|
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.integer  "language_id",           :null => false
    t.string   "title",                 :null => false
    t.text     "description"
    t.integer  "ipaper_id"
    t.string   "ipaper_access_key"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["creator_id"], :name => "index_documents_on_creator_id"
  add_index "documents", ["language_id"], :name => "index_documents_on_language_id"

  create_table "excercises", :force => true do |t|
    t.integer  "language_id",                       :null => false
    t.text     "text",                              :null => false
    t.integer  "excercise_type",                    :null => false
    t.text     "generated"
    t.boolean  "is_private",     :default => false, :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "excercises", ["language_id"], :name => "index_excercises_on_language_id"

  create_table "excercises_results", :force => true do |t|
    t.integer  "excercise_id",                      :null => false
    t.integer  "teacher_id",                        :null => false
    t.integer  "pupil_id",                          :null => false
    t.text     "result"
    t.boolean  "is_finished",    :default => false
    t.integer  "mistakes_count"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "excercises_results", ["excercise_id"], :name => "index_excercises_results_on_excercise_id"
  add_index "excercises_results", ["pupil_id"], :name => "index_excercises_results_on_pupil_id"
  add_index "excercises_results", ["teacher_id"], :name => "index_excercises_results_on_teacher_id"

  create_table "feed_urls", :force => true do |t|
    t.string   "url",         :null => false
    t.integer  "language_id", :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_urls", ["language_id"], :name => "index_feed_urls_on_language_id"

  create_table "forum_posts", :force => true do |t|
    t.text     "body",           :null => false
    t.integer  "forum_topic_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "forum_posts", ["creator_id"], :name => "index_forum_posts_on_creator_id"
  add_index "forum_posts", ["forum_topic_id"], :name => "index_forum_posts_on_forum_topic_id"

  create_table "forum_topics", :force => true do |t|
    t.string   "title",        :null => false
    t.integer  "forum_id",     :null => false
    t.integer  "last_post_by"
    t.datetime "last_post_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_topics", ["forum_id"], :name => "index_forum_topics_on_forum_id"
  add_index "forum_topics", ["last_post_by"], :name => "index_forum_topics_on_last_post_by"

  create_table "forums", :force => true do |t|
    t.string   "title",        :null => false
    t.integer  "language_id",  :null => false
    t.integer  "last_post_by"
    t.datetime "last_post_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "forums", ["language_id"], :name => "index_forums_on_language_id"
  add_index "forums", ["last_post_by"], :name => "index_forums_on_last_post_by"

  create_table "languages", :force => true do |t|
    t.string   "code",       :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "learning_language_users", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "language_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "learning_language_users", ["language_id"], :name => "index_learning_language_users_on_language_id"
  add_index "learning_language_users", ["user_id"], :name => "index_learning_language_users_on_user_id"

  create_table "meetings", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.datetime "datetime_from", :null => false
    t.datetime "datetime_to",   :null => false
    t.text     "notice"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meetings", ["user_id"], :name => "index_meetings_on_user_id"

  create_table "meetings_users", :force => true do |t|
    t.integer  "meeting_id", :null => false
    t.integer  "user_id",    :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meetings_users", ["meeting_id"], :name => "index_meetings_users_on_meeting_id"
  add_index "meetings_users", ["user_id"], :name => "index_meetings_users_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id",                            :null => false
    t.integer  "recipient_id",                         :null => false
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject",                              :null => false
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "messages", ["recipient_id"], :name => "index_messages_on_recipient_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "pupils_teachers", :force => true do |t|
    t.integer  "pupil_id",    :null => false
    t.integer  "teacher_id",  :null => false
    t.integer  "language_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pupils_teachers", ["language_id"], :name => "index_pupils_teachers_on_language_id"
  add_index "pupils_teachers", ["pupil_id"], :name => "index_pupils_teachers_on_pupil_id"
  add_index "pupils_teachers", ["teacher_id"], :name => "index_pupils_teachers_on_teacher_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "teaching_language_users", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "language_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teaching_language_users", ["language_id"], :name => "index_teaching_language_users_on_language_id"
  add_index "teaching_language_users", ["user_id"], :name => "index_teaching_language_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                      :default => "",    :null => false
    t.string   "encrypted_password",          :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                              :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "skype_name"
    t.boolean  "is_admin",                                   :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "application_language_code",                                     :null => false
    t.string   "time_zone",                                                     :null => false
    t.integer  "new_messages_count",                         :default => 0
    t.integer  "unfinished_excercises_count",                :default => 0
    t.integer  "unviewed_meetings_count",                    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "interests"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.integer  "language_id",         :null => false
    t.string   "title",               :null => false
    t.text     "description"
    t.string   "embed_provider"
    t.string   "embed_id"
    t.string   "embed_thumbnail_url"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["creator_id"], :name => "index_videos_on_creator_id"
  add_index "videos", ["language_id"], :name => "index_videos_on_language_id"

end

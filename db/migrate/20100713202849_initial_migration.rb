class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.string :name
      t.string :skype_name
      t.boolean :is_admin, :default => false
      t.string   :avatar_file_name
      t.string   :avatar_content_type
      t.integer  :avatar_file_size
      t.datetime :avatar_updated_at
      t.string  :application_language_code, :null => false
      t.string  :time_zone, :null => false
      t.integer  :new_messages_count, :default => 0
      t.integer  :unfinished_excercises_count, :default => 0
      t.integer  :unviewed_meetings_count, :default => 0

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true

    create_table :teaching_language_users do |t|
      t.integer  :user_id, :null => false
      t.integer  :language_id, :null => false
      t.timestamps
    end

    add_index :teaching_language_users, :language_id
    add_index :teaching_language_users, :user_id

    create_table :pupils_teachers do |t|
      t.integer  :pupil_id, :null => false
      t.integer  :teacher_id, :null => false
      t.integer  :language_id, :null => false
      t.timestamps
    end

    add_index :pupils_teachers, :pupil_id
    add_index :pupils_teachers, :teacher_id
    add_index :pupils_teachers, :language_id

    create_table :learning_language_users do |t|
      t.integer  :user_id, :null => false
      t.integer  :language_id, :null => false
      t.timestamps
    end

    add_index :learning_language_users, :language_id
    add_index :learning_language_users, :user_id

    create_table :languages do |t|
      t.string :code, :null => false
      t.userstamps
      t.timestamps
    end

    create_table :comments do |t|
      t.text :comment, :null => false
      t.integer :commentable_id, :null => false
      t.string :commentable_type, :null => false
      t.userstamps
      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :creator_id

    create_table :documents do |t|
      t.string :document_file_name
      t.string :document_content_type
      t.integer :document_file_size
      t.integer :language_id, :null => false
      t.string :title, :null => false
      t.text :description
      t.integer :ipaper_id
      t.string :ipaper_access_key
      t.userstamps
      t.timestamps
    end

    add_index :documents, :language_id
    add_index :documents, :creator_id

    create_table :feed_urls do |t|
      t.string :url, :null => false
      t.integer :language_id, :null => false
      t.userstamps
      t.timestamps
    end

    add_index :feed_urls, :language_id

    create_table :forum_posts do |t|
      t.text :body, :null => false
      t.integer :forum_topic_id, :null => false
      t.timestamps
      t.userstamps
    end

    add_index :forum_posts, :forum_topic_id
    add_index :forum_posts, :creator_id

    create_table :forum_topics do |t|
      t.string :title, :null => false
      t.integer :forum_id, :null => false
      t.integer :last_post_by
      t.datetime :last_post_at
      t.userstamps
      t.timestamps
    end

    add_index :forum_topics, :last_post_by
    add_index :forum_topics, :forum_id

    create_table :forums do |t|
      t.string :title, :null => false
      t.integer :language_id, :null => false
      t.integer :last_post_by
      t.datetime :last_post_at
      t.timestamps
      t.userstamps
    end

    add_index :forums, :last_post_by
    add_index :forums, :language_id

    create_table :videos do |t|
      t.integer :language_id, :null => false
      t.string :title, :null => false
      t.text :description
      t.string :embed_provider
      t.string :embed_id
      t.string :embed_thumbnail_url
      t.userstamps
      t.timestamps
    end

    add_index :videos, :language_id
    add_index :videos, :creator_id

    create_table :messages do |t|
      t.integer :sender_id, :null => false
      t.integer  :recipient_id, :null => false
      t.boolean :sender_deleted, :recipient_deleted, :default => false
      t.string :subject, :null => false
      t.text :body
      t.datetime :read_at
      t.timestamps
      t.userstamps
    end

    add_index :messages, :sender_id
    add_index :messages, :recipient_id

    create_table :activities do |t|
      t.integer :actor_id, :null => false
      t.integer :subject_id, :null => false
      t.integer :target_id
      t.string :subject_type, :null => false
      t.string :action, :null => false
      t.timestamp :created_at, :null => false
    end

    add_index :activities, :actor_id
    add_index :activities, :target_id
    add_index :activities, [:subject_id, :subject_type]

    create_table :excercises do |t|
      t.integer :language_id, :null => false
      t.text :text, :null => false
      t.integer :excercise_type, :null => false
      t.text :generated
      t.boolean :is_private, :default => false, :null => false
      t.userstamps
      t.timestamps
    end

    add_index :excercises, :language_id

    create_table :excercises_results do |t|
      t.integer :excercise_id, :null => false
      t.integer :teacher_id, :null => false
      t.integer :pupil_id, :null => false
      t.text :result
      t.boolean :is_finished, :default => false
      t.integer :mistakes_count
      t.userstamps
      t.timestamps
    end

    add_index :excercises_results, :excercise_id
    add_index :excercises_results, :teacher_id
    add_index :excercises_results, :pupil_id

    create_table :meetings do |t|
      t.integer :user_id, :null => false
      t.datetime :datetime_from, :null => false
      t.datetime :datetime_to, :null => false
      t.text :notice
      t.userstamps
      t.timestamps
    end

    add_index :meetings, :user_id

    create_table :meetings_users do |t|
      t.integer :meeting_id, :null => false
      t.integer :user_id, :null => false
      t.userstamps
      t.timestamps
    end

    add_index :meetings_users, :meeting_id
    add_index :meetings_users, :user_id

    create_table :histories do |t|
      t.string :message # title, name, or object_id
      t.string :username
      t.integer :item
      t.string :table
      t.integer :month, :limit => 2
      t.integer :year, :limit => 5
      t.timestamps
    end
    add_index(:histories, [:item, :table, :month, :year])

  end

  def self.down
    drop_table :users
    drop_table :teaching_language_users
    drop_table :pupils_teachers
    drop_table :learning_language_users
    drop_table :languages
    drop_table :comments
    drop_table :documents
    drop_table :feed_urls
    drop_table :forum_posts
    drop_table :forum_topics
    drop_table :forums
    drop_table :videos
    drop_table :messages
    drop_table :activities
    drop_table :excercises
    drop_table :excercises_results
    drop_table :meetings
    drop_table :meetings_users
    drop_table :histories
  end
end
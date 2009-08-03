class AddDefaultUsers < ActiveRecord::Migration
  def self.up
    self.users.each do |data|
      say_with_time "created user: " + data["login"] do
        User.new(data).save!
      end
    end
  end

  def self.down
    self.users.each do |data|
      say_with_time("deleted user: " + data["login"]) do
        user = User.find_by_login(data["login"])
        user.destroy unless user.nil?
      end
    end
  end

  def self.users
    default_users_path = RAILS_ROOT + "/config/default_users.yml"
    return [] unless File.exists? default_users_path
    return YAML.load_file(default_users_path)
  end
end

if Rails.env.production?
  task :delete_old_targets do
    Target.where('created_at < ?', 1.week.ago.utc).destroy_all
  end
end

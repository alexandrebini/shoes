def seed(klass)
  seed_file = File.open("#{ Rails.root }/db/seed/#{ klass.to_s.underscore.pluralize }.yml")
  config = YAML::load_file(seed_file)
  klass.create config
end

seed Category
seed Store
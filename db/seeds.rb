def seed(klass)
  seed_file = ERB.new(File.read("#{ Rails.root }/db/seed/#{ klass.to_s.underscore.pluralize }.yml")).result
  config = YAML.load(seed_file)
  klass.create(config)
end

seed Brand
seed Category
seed Palette
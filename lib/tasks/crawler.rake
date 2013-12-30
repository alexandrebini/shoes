require "#{ Rails.root }/lib/crawler/crawler"

namespace :crawler do
  desc 'import all shoes'
  task start: :environment do
    [
      Thread.new{ Crawler::Carmensteffens.start! },
      Thread.new{ Crawler::Corello.start! },
      Thread.new{ Crawler::Louloux.start! },
      Thread.new{ Crawler::Melissa.start! },
      Thread.new{ Crawler::Schutz.start! }
    ].each(&:join)
  end

  desc 'start downloads'
  task download: :environment do
    Shoe.pending.random.limit(jobs).each do |shoe|
      shoe.download_image
    end
  end
end
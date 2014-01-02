namespace :crawler do
  desc 'import all shoes'
  task start: :environment do
    klasses = [
      Crawler::Carmensteffens,
      Crawler::Corello,
      Crawler::Louloux,
      Crawler::Melissa,
      Crawler::Miezko,
      Crawler::Schutz
    ]
    pids = klasses.map do |klass|
      Process.fork do
        puts "Starting: #{ klass }"
        klass.start!
      end
    end
    pids.each do |pid|
      Process.wait(pid)
    end
  end

  desc 'start downloads'
  task download: :environment do
    Shoe.pending.random.limit(jobs).each do |shoe|
      shoe.download_image
    end
  end
end
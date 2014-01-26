namespace :crawler do
  desc 'import all shoes'
  task start: :environment do
    klasses = [
      Crawler::Carmensteffens,
      Crawler::Corello,
      Crawler::Louloux,
      Crawler::Melissa,
      Crawler::Miezko,
      Crawler::Schutz,
      Crawler::Tanara
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
    shoes = Shoe.pending
    count = shoes.count
    limit = 10

    while count > 0
      shoes.random.limit(limit).each do |shoe|
        shoe.photos.each{ |photo| photo.download_image }
      end

      count -= limit
    end
  end
end
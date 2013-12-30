namespace :crawler do
  desc 'import all shoes'
  task start: :environment do
    klasses = [
      Crawler::Carmensteffens,
      Crawler::Corello,
      Crawler::Louloux,
      Crawler::Melissa,
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

  desc 'import Carmensteffens'
  task carmensteffens: :environment do
    Crawler::Carmensteffens.start!
  end

  desc 'import Corello'
  task corello: :environment do
    Crawler::Corello.start!
  end

  desc 'import Louloux'
  task louloux: :environment do
    Crawler::Louloux.start!
  end

  desc 'import Melissa'
  task melissa: :environment do
    Crawler::Melissa.start!
  end

  desc 'import Schutz'
  task schutz: :environment do
    Crawler::Schutz.start!
  end
end
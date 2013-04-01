namespace :alaskan do
  namespace :pipeline do
    task :init => :environment do
      if defined?(Rails)
        Rails.logger = Logger.new(STDOUT)
      end
    end

    task :load => :init do
      if ENV['BOARD_ID'].blank?
        puts "Provide the id of the Trello board you'd like to analyze. Get it from the URL, e.g. https://trello.com/board/engineering-pipeline/4e722f28fbeaad21d6017682."
        exit
      end

      pipeline = Pipeline.build_from_board(Trello::Board.find(ENV['BOARD_ID']))
      pipeline.save!
    end
  end
end

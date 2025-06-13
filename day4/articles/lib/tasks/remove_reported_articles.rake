namespace :articles do
  desc "Remove articles reported 6 or more times"
  task remove_reported_articles: :environment do
    Article.where('reports_count >= ?', 6).destroy_all
    puts "Removed reported articles at #{Time.current}"
  end
end

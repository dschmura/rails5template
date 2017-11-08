rakefile "favicon.rake" do
  %Q{
namespace :favicon do
  desc "generate a favicon"
  task generate: :environment do
    system <<~SYSTEM
    sketchtool export artboards \#{Rails.root}/doc/favicon.sketch --output=\#{Rails.root}/tmp
    convert \#{Rails.root}/tmp/favicon-*.png \#{Rails.root}/public/favicon.ico
    rm \#{Rails.root}/tmp/favicon-*
    SYSTEM
  end
end
  }
end
insert_into_file "README.md", after: "* System dependencies\n" do
  <<-BOURBON_README

    ## Styling - Bourbon
     This application uses Bourbon as part of it's styling.

  BOURBON_README
end

  insert_into_file 'app/assets/stylesheets/application.scss', after: "*/\n" do
  # "\n@charset 'utf-8';
  # \n@import 'normalize-rails';
  "\n@import 'bourbon';
   \n@import 'neat';"
  # \n@import 'base/base';
  end

  append_to_file 'Gemfile' do
    "\ngem 'bourbon'
    \ngem 'neat', '~> 1.8'
    \ngem 'bitters'"
  end
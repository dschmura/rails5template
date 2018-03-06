# We will create a temporary favicon for using the faviator npm package.
# Requires faviator be installed. To install run;
# npm install -g faviator

run ("faviator --size '230' --text #{app_name[0].upcase} --dx '-5' --dy '2' --font-size '70' --font-family 'Pacifico' --font-color '#ffffff' --background-color '#465D85' --border-width '3.5' --border-color '#97ABBF' --border-radius '50' --output app/webpacker/#{app_name}/images/favicon.png")


append_to_file 'app/views/layouts/application.html.haml', after: '%title= page_title' do
  <<-FAVICON

    = favicon_link_tag asset_pack_path('tada/images/favicon.png')
  FAVICON
end

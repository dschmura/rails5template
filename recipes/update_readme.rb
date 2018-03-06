insert_into_file "README.md", after: "* Configuration\n" do
  <<-STYLES_README

  * Code Style Guidelines

  We have some opinions about how code is written and formatted. We aim for clarity and human readability.

    ### Formatting
      Use 2 spaces for indenting.

    ### Naming

      ruby_methods_use_snake_case

      javascript-methods-use-kebab-case

      css-class-declarations-use-kebab-case

  STYLES_README
end

insert_into_file "README.md", after: "* System dependencies\n" do
  <<-BOURBON_README

    ## Styling
     This application uses Bourbon as part of it's styling.

  BOURBON_README
end

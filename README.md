# Rails 5 Template

This is a template for building new rails 5 applications with my defaults. It uses haml, bourbon, neat, font-awesome, rspec (instead of MiniTest) and generates a basic site structure.

## Gems

- haml
<!-- - bourbon -->
<!-- - neat -->
<!-- - font-aweseom-rails -->
- rspec
- factory_bot
- capistrano
<!-- - twitter-bootstrap v4? -->


## yarn

- Turbolinks
- stimulus
- jquery 3
- rails-ujs
- bourbon
- bootstrap 4


## Generators


## Git


## Dependencies
[Forego](https://dl.equinox.io/ddollar/forego/stable)
Foreman written in go.

### Usage
```
$ cat Procfile
web: bin/web start -p $PORT
worker: bin/worker queue=FOO

$ forego start
web    | listening on port 5000
worker | listening to queue FOO
```

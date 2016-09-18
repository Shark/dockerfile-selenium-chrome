# dockerfile-selenium-chrome

This repository contains a Dockerfile for running the [Chromium Browser](https://www.chromium.org/) along with [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/) as a [Selenium](http://docs.seleniumhq.org/) remote service. This allows an app running in another container to run browser tests in a container.

Part of this setup is taken from [RobCherry/docker-selenium](https://github.com/RobCherry/docker-selenium).

## Usage

Run either `docker pull sh4rk/selenium-chrome` or build the image yourself with `docker build -t sh4rk/selenium-chrome .`.

See `docker-compose.yml` for an example on how to use this image.

You'll have to configure your test runner to access the remote Selenium instance. If you're using [capybara](https://github.com/jnicklas/capybara) for [Ruby on Rails](http://rubyonrails.org/), you can put the following into your `rails_helper.rb`:

```ruby
Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app,
      browser: :remote,
      desired_capabilities: :chrome,
      url: "http://#{ENV['CHROME_HOSTNAME']}:4444/wd/hub"
    )
  end
  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = Capybara::Server.new(Rails.application).send(:find_available_port, Capybara.server_host)
  Capybara.app_host = "http://#{`ip address show eth0 | grep inet | head -n1 | awk '{print $2}' | cut -d/ -f 1`.strip}:#{Capybara.server_port}"
  Capybara.javascript_driver = :chrome
```

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request! :)

## History

- v0.1.0 (2016-09-18): initial version

## License

This project is licensed under the MIT License. See LICENSE for details.

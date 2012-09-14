# Rake::RemoteChef

Rake::RemoteChef can run chef-solo on remote host using Rake.

## Installation

Add this line to your application's Gemfile:

    gem 'rake-remote_chef'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rake-remote_chef

## Usage

    $ rake chef:bootstrap   # first time only. (Install chef-solo on remote host.)
    $ rake chef:solo

## Setup

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

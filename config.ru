require 'rubygems'
require 'bundler'

require File.join(Dir.pwd, 'rules.rb')
require File.join(Dir.pwd, 'storage.rb')
require File.join(Dir.pwd, 'server.rb')

Bundler.require

require './core.rb'
run FroudProtect
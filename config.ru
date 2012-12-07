require 'rubygems'
require 'bundler'
require 'json'

Bundler.require

require File.join(Dir.pwd, 'rules.rb')
require File.join(Dir.pwd, 'server.rb')

require './core.rb'
run FroudProtect
#!/usr/bin/env ruby

require 'rubygems'
require 'ssh-copy-id'
require 'optparse'

options = SSHCopyID.parse_options(__FILE__, ARGV)
SSHCopyID.grant({:hosts => ARGV.uniq, :output => STDOUT}.merge(options))

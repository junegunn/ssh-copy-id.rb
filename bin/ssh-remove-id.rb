#!/usr/bin/env ruby

require 'rubygems'
require 'ssh-copy-id'
require 'optparse'

options = SSHCopyID.parse_options(__FILE__, ARGV)
SSHCopyID.revoke({:hosts => ARGV.uniq, :output => STDOUT}.merge(options))

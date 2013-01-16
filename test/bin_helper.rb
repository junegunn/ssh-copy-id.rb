#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib')
load File.join(File.dirname(__FILE__), '../bin/', File.basename(ARGV.shift))

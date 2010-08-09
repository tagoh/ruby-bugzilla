# rhbugzilla.rb
# Copyright (C) 2010 Red Hat, Inc.
#
# Authors:
#   Akira TAGOH  <tagoh@redhat.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

require 'rubygems'

#begin
#  gem 'ruby-bugzilla'
#rescue Gem::LoadError
#  require File.join(File.dirname(__FILE__), "..", "bugzilla.rb")
#end

module Bugzilla

  module Plugin

    class RedHat < ::Bugzilla::Plugin::Template

      def initialize
        super

	@hostname = "bugzilla.redhat.com"
      end # def initialize

      def parserhook(parser, argv, opts)
	parser.separator ""
        parser.separator "RH Bugzilla specific options:"
        parser.on('--cc=EMAILS', 'filter out the result by Cc in bugs') {|v| opts[:query][:cc] ||= []; opts[:query][:cc].push(*v.split(','))}
      end # def parserhook

      def prehook(cmd, opts)
	case cmd
        when :search
          extra_field = 0

          if opts.include?(:status) then
            opts[:bug_status] = opts[:status]
            opts.delete(:status)
          end
          if opts.include?(:id) then
            opts[:bug_id] = opts[:id]
            opts.delete(:id)
          end
          if opts.include?(:severity)
            opts[:bug_severity] = opts[:severity]
          end
          if opts.include?(:summary) then
            opts[:short_desc] = opts[:summary]
            opts.delete(:summary)
          end
          if opts.include?(:cc) then
            i = 1
            opts[:cc].each do |e|
              opts[eval(":emailcc#{i}")] = 1
              opts[eval(":emailtype#{i}")] = :substring
              opts[eval(":email#{i}")] = e
            end
            opts.delete(:cc)
          end
          if opts.include?(:creation_time) then
            opts[sprintf("field0-%d-0", extra_field)] = :creation_ts
            opts[sprintf("type0-%d-0", extra_field)] = :greaterthan
            opts[sprintf("value0-%d-0", extra_field)] = opts[:creation_time]
            opts.delete(:creation_time)
          end
        else
        end
      end # def prehook

      def posthook(cmd, opts)
	case cmd
        when :search
          if opts.include?('bugs') then
            opts['bugs'].each do |bug|
              if bug.include?('bug_status') then
                bug['status'] = bug['bug_status']
                bug.delete('bug_status')
              end
              if bug.include?('bug_id') then
                bug['id'] = bug['bug_id']
                bug.delete('bug_id')
              end
              if bug.include?('bug_severity') then
                bug['severity'] = bug['bug_severity']
                bug.delete('bug_severity')
              end
              if bug.include?('short_desc') then
                bug['summary'] = bug['short_desc']
                bug.delete('short_desc')
              end
            end
          end
        else
        end
      end # def posthook

    end # class RedHat

  end # module Plugin

end # module Bugzilla

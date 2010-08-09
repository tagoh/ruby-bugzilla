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

          if opts[:command][:query].include?(:status) then
            opts[:command][:query][:bug_status] = opts[:command][:query][:status]
            opts[:command][:query].delete(:status)
          end
          if opts[:command][:query].include?(:id) then
            opts[:command][:query][:bug_id] = opts[:command][:query][:id]
            opts[:command][:query].delete(:id)
          end
          if opts[:command][:query].include?(:severity)
            opts[:command][:query][:bug_severity] = opts[:command][:query][:severity]
          end
          if opts[:command][:query].include?(:summary) then
            opts[:command][:query][:short_desc] = opts[:command][:query][:summary]
            opts[:command][:query].delete(:summary)
          end
          if opts[:command][:query].include?(:cc) then
            i = 1
            opts[:command][:query][:cc].each do |e|
              opts[:command][:query][eval(":emailcc#{i}")] = 1
              opts[:command][:query][eval(":emailtype#{i}")] = :substring
              opts[:command][:query][eval(":email#{i}")] = e
            end
            opts[:command][:query].delete(:cc)
          end
          if opts[:command][:query].include?(:creation_time) then
            opts[:command][:query][sprintf("field0-%d-0", extra_field)] = :creation_ts
            opts[:command][:query][sprintf("type0-%d-0", extra_field)] = :greaterthan
            opts[:command][:query][sprintf("value0-%d-0", extra_field)] = opts[:command][:query][:creation_time]
            opts[:command][:query].delete(:creation_time)
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

# rhbugzilla.rb
# Copyright (C) 2010-2012 Red Hat, Inc.
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

      def parserhook(*args)
        parser, argv, opts, *etc = args
	parser.separator ""
        parser.separator "RH Bugzilla specific options:"
        parser.on('--cc=EMAILS', 'filter out the result by Cc in bugs') {|v| opts[:query][:cc] ||= []; opts[:query][:cc].push(*v.split(','))}
        parser.on('--filterversion=VERSION', 'filter out the result by the version in bugs') {|v| opts[:query][:version] ||= []; opts[:query][:version].push(*v.split(','))}
      end # def parserhook

      def prehook(*args)
        cmd, opts, *etc = args
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
        when :metrics
          metricsopts = etc[0]
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
            if opts[:creation_time].kind_of?(Array) then
              opts[sprintf("field0-%d-0", extra_field)] = :creation_ts
              opts[sprintf("type0-%d-0", extra_field)] = :greaterthan
              opts[sprintf("value0-%d-0", extra_field)] = opts[:creation_time][0]
              extra_field += 1
              opts[sprintf("field0-%d-0", extra_field)] = :creation_ts
              opts[sprintf("type0-%d-0", extra_field)] = :lessthan
              opts[sprintf("value0-%d-0", extra_field)] = opts[:creation_time][1]
              extra_field += 1
            else
              opts[sprintf("field0-%d-0", extra_field)] = :creation_ts
              opts[sprintf("type0-%d-0", extra_field)] = :greaterthan
              opts[sprintf("value0-%d-0", extra_field)] = opts[:creation_time]
              extra_field += 1
            end
            opts.delete(:creation_time)
          end
          if opts.include?(:last_change_time) then
            if opts[:last_change_time].kind_of?(Array) then
              opts[:chfieldfrom] = opts[:last_change_time][0]
              opts[:chfieldto] = opts[:last_change_time][1]
              if opts[:bug_status] == 'CLOSED' then
                opts[sprintf("field0-%d-0", extra_field)] = :bug_status
                opts[sprintf("type0-%d-0", extra_field)] = :changedto
                opts[sprintf("value0-%d-0", extra_field)] = opts[:bug_status]
                extra_field += 1
              end
            end
            opts.delete(:last_change_time)
          end
          if opts.include?(:metrics_closed_after) then
            opts[sprintf("field0-%d-0", extra_field)] = :bug_status
            opts[sprintf("type0-%d-0", extra_field)] = :changedafter
            opts[sprintf("value0-%d-0", extra_field)] = opts[:metrics_closed_after]
            extra_field += 1
            opts.delete(:metrics_closed_after)
          end
          if opts.include?(:metrics_not_closed) then
            opts[sprintf("field0-%d-0", extra_field)] = :bug_status
            opts[sprintf("type0-%d-0", extra_field)] = :notequals
            opts[sprintf("value0-%d-0", extra_field)] = 'CLOSED'
            extra_field += 1
            opts[sprintf("field0-%d-0", extra_field)] = :creation_ts
            opts[sprintf("type0-%d-0", extra_field)] = :lessthan
            opts[sprintf("value0-%d-0", extra_field)] = opts[:metrics_not_closed]
            extra_field += 1
            opts.delete(:metrics_not_closed)
          end
        else
        end
      end # def prehook

      def posthook(*args)
        cmd, opts, *etc = args
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
        when :metrics
          metricsopts = etc[0]

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

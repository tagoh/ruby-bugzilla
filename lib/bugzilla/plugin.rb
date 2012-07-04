# plugin.rb
# Copyright (C) 2010-2012 Red Hat, Inc.
#
# Authors:
#   Akira TAGOH  <tagoh@redhat.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.


module Bugzilla

=begin rdoc

=== Bugzilla::Plugin

=end

  module Plugin

=begin rdoc

==== Bugzilla::Plugin::Template

=end

    class Template
      @@plugins = []

      def initialize
	@hostname = nil
      end # def initialize

      attr_reader :hostname

      def Template.inherited(subclass)
	@@plugins << subclass
      end # def inherited

      def run(hook, host, *args)
        @@plugins.each do |k|
          i = k.new
          if i.hostname == host || host.nil? then
            case hook
            when :parser
              i.parserhook(*args)
            when :pre
              i.prehook(*args)
            when :post
              i.posthook(*args)
            else
            end
          end
        end
      end # def run

      def parserhook(parser, argv, opts)
      end # def parserhook

      def prehook(cmd, opts)
      end # def prehook

      def posthook(cmd, opts)
      end # def posthook

    end # class Template

  end # module Plugin

end # module Bugzilla

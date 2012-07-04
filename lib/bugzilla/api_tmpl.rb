# api_tmpl.rb
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

require 'bugzilla/skeleton'
require 'bugzilla/bugzilla'


module Bugzilla

=begin rdoc

=== Bugzilla::APITemplate

=end

  class APITemplate < Skeleton

    def initialize(iface)
      super

      @bz = Bugzilla.new(iface)
    end # def initialize

    def method_missing(symbol, *args)
      if @bz.respond_to?(symbol) then
        @bz.__send__(symbol, *args)
      else
        super
      end
    end # def method_missing

  end # class APITemplate

end # module Bugzilla

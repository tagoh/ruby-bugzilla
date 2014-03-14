# skeleton.rb
# Copyright (C) 2010-2012 Red Hat, Inc.
#
# Authors:
#   Akira TAGOH  <tagoh@redhat.com>
#
# This library is free software: you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


module Bugzilla

=begin rdoc

=== Bugzilla::Skeleton

=end

  class Skeleton

    def initialize(iface)
      @iface = iface
    end # def initialize

    def method_missing(symbol, *args)
      m = "_#{symbol}"
      klass = self.class.to_s.sub(/\ABugzilla::/, '')
      fm = "#{klass}.#{symbol}"
      if self.respond_to?(m, true) then
        __send__(m, fm, *args)
      else
        raise NoMethodError, sprintf("No such Bugzilla APIs: %s.%s", klass, symbol)
      end
    end # def method_missing

  end # class Skeleton

end # module Bugzilla

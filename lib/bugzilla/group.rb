# group.rb
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

require 'bugzilla/api_tmpl'

module Bugzilla

=begin rdoc

=== Bugzilla::Group

Bugzilla::Group class is to access
the Bugzilla::WebService::Group API that allows you to
create Groups and get information about them.

=end

  class Group < APITemplate

    def __create(cmd, *args)
      # FIXME
    end # def _create

    def __update(cmd, *args)
      # FIXME
    end # def _update

  end # class Group

end # module Bugzilla

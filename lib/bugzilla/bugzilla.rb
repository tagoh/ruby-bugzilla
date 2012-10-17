# bugzilla.rb
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

require 'bugzilla/skeleton'

module Bugzilla

=begin rdoc

=== Bugzilla::Bugzilla

Bugzilla::Bugzilla class is to access the
Bugzilla::WebService::Bugzilla API that provides functions
tell you about Bugzilla in general.

=end

  class Bugzilla < Skeleton

=begin rdoc

==== Bugzilla::Bugzilla#check_version(version_)

Returns Array contains the result of the version check and
Bugzilla version that is running on.

=end

    def check_version(version_)
      v = version
      f = false
      if v.kind_of?(Hash) && v.include?("version") &&
          v['version'] >= "#{version_}" then
	f = true
      end

      [f, v['version']]
    end # def check_version

=begin rdoc

==== Bugzilla::Bugzilla#requires_version(cmd, version_)

Raise an exception if the Bugzilla doesn't satisfy
the requirement of the _version_.

=end

    def requires_version(cmd, version_)
      v = check_version(version_)
      raise NoMethodError, sprintf("%s is not supported in Bugzilla %s", cmd, v[1]) unless v[0]
    end # def requires_version

=begin rdoc

==== Bugzilla::Bugzilla#version

Raw Bugzilla API to obtain the Bugzilla version.

See http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Bugzilla.html

=end

=begin rdoc

==== Bugzilla::Bugzilla#extensions

Raw Bugzilla API to obtain the information about
the extensions that are currently installed and enabled in
the Bugzilla.

See http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Bugzilla.html

=end

=begin rdoc

==== Bugzilla::Bugzilla#timezone

Raw Bugzilla API to obtain the timezone that Bugzilla
expects dates and times in.

See http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Bugzilla.html

=end

=begin rdoc

==== Bugzilla::Bugzilla#time

Raw Bugzilla API to obtain the information about what time
the bugzilla server thinks it is, and what timezone it's
running on.

See http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Bugzilla.html

=end

    protected

    def _version(cmd, *args)
      @iface.call(cmd)
    end # def _version

    def _extensions(cmd, *args)
      requires_version(cmd, 3.2)

      @iface.call(cmd)
    end # def _extensions

    def _timezone(cmd, *args)
      @iface.call(cmd)
    end # def _timezone

    def _time(cmd, *args)
      requires_version(cmd, 3.4)

      @iface.call(cmd)
    end # def _time

  end # class Bugzilla

end # module Bugzilla

# classification.rb
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

=== Bugzilla::Classification

Bugzilla::Classification class is to access
the Bugzilla::WebService::Classification API that allows you
to deal with the available Classifications.

=end

  class Classification < APITemplate

=begin rdoc

==== Bugzilla::Classification#get(params)

Raw Bugzilla API to obtain the information about a set of
classifications.

See http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Classification.html

=end

    def _get(cmd, args[0])
      requires_version(cmd, 4.4)

      params = {}

      if ids.kind_of?(Hash) then
        raise ArgumentError, sprintf("Invalid parameter: %s", ids.inspect) unless ids.include?('ids') || ids.include?('names')
        params[:ids] = ids['ids'] || ids['names']
      elsif ids.kind_of?(Array) then
	r = ids.map {|x| x.kind_of?(Integer) ? x : nil}.compact
        if r.length != ids.length then
          params[:names] = ids
        else
          params[:ids] = ids
        end
      else
        if ids.kind_of?(Integer) then
          params[:ids] = [ids]
        else
          params[:names] = [ids]
        end
      end

      @iface.call(cmd, params)
    end # def _get

  end # class Classification

end # module Bugzilla


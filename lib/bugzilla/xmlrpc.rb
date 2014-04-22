# xmlrpc.rb
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

require 'xmlrpc/client'

module Bugzilla

=begin rdoc

=== Bugzilla::XMLRPC

=end

  class XMLRPC

=begin rdoc

==== Bugzilla::XMLRPC#new(host, port = 443, path = '/xmlrpc.cgi', proxy_host = nil, proxy_port = nil)

=end

    def initialize(host, port = 443, path = '/xmlrpc.cgi', proxy_host = nil, proxy_port = nil, timeout = 60)
      path ||= '/xmlrpc.cgi'
      use_ssl = port == 443 ? true : false
      @xmlrpc = ::XMLRPC::Client.new(host, path, port, proxy_host, proxy_port, nil, nil, use_ssl, timeout)
    end # def initialize

=begin rdoc

==== Bugzilla::XMLRPC#call(cmd, params, user = nil, password = nil)

=end

    def call(cmd, params = {}, user = nil, password = nil)
      params = {} if params.nil?
      params['Bugzilla_login'] = user unless user.nil? || password.nil?
      params['Bugzilla_password'] = password unless user.nil? || password.nil?
      params['Bugzilla_token'] = @token unless @token.nil?
      @xmlrpc.call(cmd, params)
    end # def call

=begin rdoc

==== Bugzilla::XMLRPC#cookie

=end

    def cookie
      @xmlrpc.cookie
    end # def cookie

=begin rdoc

==== Bugzilla::XMLRPC#cookie=(val)

=end

    def cookie=(val)
      @xmlrpc.cookie = val
    end # def cookie

=begin rdoc

==== Bugzilla::XMLRPC#token

=end

    def token
      @token
    end # def token

=begin rdoc

==== Bugzilla::XMLRPC#token=(val)

=end

    def token=(val)
      @token = val
    end # def token

  end # class XMLRPC

end # module Bugzilla

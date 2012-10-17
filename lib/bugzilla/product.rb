# product.rb
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

=== Bugzilla::Product

Bugzilla::Product class is to access
the Bugzilla::WebService::Product API that allows you to
list the available Products and get information about them.

=end

  class Product < APITemplate

=begin rdoc

==== Bugzilla::Product#selectable_products

Returns the products that the user can search on as Hash
contains the product name as the Hash key and Array as the
value. Array contains the list of _id_, _name_,
_description_ and _internals_ according to API documentation
though, actually the component, the version and the target
milestone.

=end

    def selectable_products
      ids = get_selectable_products
      get(ids)
    end # def selectable_products

=begin rdoc

==== Bugzilla::Product#enterable_products

Returns the products that the user can enter bugs against
as Hash contains the product name as the Hash key and Array
as the value. Array contains the list of _id_, _name_,
_description_ and _internals_ according to API documentation
though, actually the component, the version and the target
milestone.

=end

    def enterable_products
      ids = get_enterable_products
      get(ids)
    end # def enterable_products

=begin rdoc

==== Bugzilla::Product#accessible_products

Returns the products that the user can search or enter bugs
against as Hash contains the product name as the Hash key
and Array as the value. Array contains the list of _id_,
_name_, _description_ and _internals_ according to API
documentation though, actually the component, the version
and the target milestone.

=end

    def accessible_products
      ids = get_accessible_products
      get(ids)
    end # def accessible_products

=begin rdoc

==== Bugzilla::Product#get_selectable_products

Raw Bugzilla API to obtain the products that the user can
search on.

See http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Product.html

=end

=begin rdoc

==== Bugzilla::Product#get_enterable_products

Raw Bugzilla API to obtain the products that the user can
enter bugs against.

See http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Product.html

=end

=begin rdoc

==== Bugzilla::Product#get_accessible_products

Raw Bugzilla API to obtain the products that the user can
search or enter bugs against.

See http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/Product.html

=end

    protected

    def _get_selectable_products(cmd, *args)
      @iface.call(cmd)
    end # def _get_selectable_products

    def _get_enterable_products(cmd, *args)
      @iface.call(cmd)
    end # def _get_entrable_products

    def _get_accessible_products(cmd, *args)
      @iface.call(cmd)
    end # def _get_accessible_products

    def _get(cmd, ids, *args)
      params = {}

      if ids.kind_of?(Hash) then
        raise ArgumentError, sprintf("Invalid parameter: %s", ids.inspect) unless ids.include?('ids')
        params[:ids] = ids['ids']
      elsif ids.kind_of?(Array) then
	params[:ids] = ids
      else
        params[:ids] = [ids]
      end

      @iface.call(cmd, params)
    end # def _get

  end # class Product

end # module Bugzilla

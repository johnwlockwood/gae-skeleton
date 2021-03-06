#
# Copyright 2012 Ezox Systems LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


class App.Appname.Model.MenuItem extends Backbone.Model
    defaults: ->
        return {
            text: "",
            title: "",
            href: "",
        }


class App.Appname.Collection.MenuItems extends Backbone.Collection
    model: App.Appname.Model.MenuItem


class App.Appname.View.MenuItems extends Backbone.View
    template: JST.menuitem
    tagName: "li"
    className: "menu"

    render: =>
        @$el.html(@template(@model.toJSON()))
        @$el.prop('id', 'menu-item-' + @model.get('title'))
        return this


class App.Appname.View.Menu extends Backbone.View
    el: $("#appnameheader")

    initialize: () ->
        items = [
            {
                text: 'Person',
                title: 'person',
                href: '#\/person'
            },
        ]
        @collection = new App.Appname.Collection.MenuItems(items)
        @collection.bind('change', @render, this)

    render: =>
        menu = @$("#appname-menu")
        @collection.each((menuItem) =>
            view = new App.Appname.View.MenuItems({model: menuItem})
            menu.append(view.render().el)
        )
        return this
    

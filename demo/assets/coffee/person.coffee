#
# Copyright 2012 Ezox Systems LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# #     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


class App.Demo.Model.Person extends Backbone.Model
    idAttribute: 'key'
    urlRoot: '/service/person'
    defaults: ->
        return {
            key: "",
            name: "",
            contact_info: [],
            notes: "",
        }

    initialize: () ->
        @contact_info = @nestCollection(
            'contact_info',
            new App.Demo.Collection.ContactInfo(@get('contact_info')))

    validate: (attrs) =>
        hasError = false
        errors = {}

        if _.isEmpty(attrs.name)
            hasError = true
            errors.name = "Missing name."
            errors.property = 'name'

        if hasError
            return errors


class App.Demo.Collection.PersonList extends Backbone.Collection
    url: '/service/person'
    model: App.Demo.Model.Person


class App.Demo.View.PersonEdit extends App.Skel.View.EditView
    template: JST['person/edit']
    modelType: App.Demo.Model.Person
    focusButton: 'input#name'

    events:
        "change": "change"
        "click a.destroy": "clear"
        "click button.add_contact": "addContactInfo"
        "submit form" : "save"
        "keypress .edit": "updateOnEnter"
        "click .remove-button": "clear"
        "hidden": "close"

    save: (e) =>
        if e
            e.preventDefault()

        @model.contact_info.each((info) ->
            info.editView.close()
        )

        @model.save(
            name: @$('input.name').val()
            notes: $.trim(@$('textarea.notes').val())
        )

        return super()

    render: (asModal) =>
        el = @$el
        el.html(@template(@model.toJSON()))

        @model.contact_info.each((info, i) ->
            editView = new App.Demo.View.ContactInfoEdit({model: info})
            el.find('fieldset.contact_info').append(editView.render().el)
        )

        return super(asModal)

    addContactInfo: () =>
        newModel = new @model.contact_info.model()
        @model.contact_info.add(newModel)

        editView = new App.Demo.View.ContactInfoEdit({model: newModel})
        rendered = editView.render()
        @$el.find('fieldset.contact_info').append(rendered.el)

        rendered.$el.find('input.type').focus()

        return false

    updateOnEnter: (e) =>
        focusItem = $("*:focus")

        if e.keyCode == 13
            if focusItem.hasClass('contact')
                @addContactInfo()
                return false

        return super(e)


class App.Demo.View.PersonApp extends App.Skel.View.ModelApp
    el: $("#demoapp")
    template: JST['person/view']
    modelType: App.Demo.Model.Person
    form: App.Demo.View.PersonEdit
    module: 'Demo'

class App.Demo.View.PersonList extends App.Skel.View.ListView
    template: JST['person/list']
    modelType: App.Demo.Model.Person


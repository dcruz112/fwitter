# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



jQuery ->
  $('#user_tokens').tokenInput '/users.json',
    theme: 'facebook',
    propertyToSearch: "first_name",
    prePopulate: $('#user_tokens').data('load'),
    resultsFormatter: (item) ->
      return "<li>" + item.first_name + " " + item.last_name + " " + "<em>" + "</li>"
    tokenFormatter: (item) ->
      return "<li>" + item.first_name + " " + item.last_name + " " + "<em>" + "</li>"


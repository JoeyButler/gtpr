# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('a.issues-btn').click (event)->
    if (/populated/).test(event.target.className)
      return false
    link = $(event.target)
    $.get link.attr('href'), (data)->
      console.log(data)
      link.parent().append HandlebarsTemplates['repos/index'](data)
      link.addClass('populated')
      link.href = null
    event.preventDefault()

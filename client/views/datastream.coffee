Template.datastream.loaded = -> Session.equals("dataSubReady", true)

Template.datastream.data = ->
  Datastream.find({}, sort: {num: 1}) # Sort in increasing insertion order

Template.datastream.visible = ->
  # Order in which we register reactive dependencies with short-circuit boolean matters here for efficiency
  if @events? and @events.length > 0
    return false # Session.equals("data-tagged", true)
  else if @hidden
    return false # Session.equals("data-hidden", true)
  else
    return true # Session.equals("data-unfiltered", true)

Template.datastream.events =
  "click .action-data-hide": ->
    Meteor.call "dataHide", @_id

dragHelper = ->
  # Make sure we are on events
  Mapper.switchTab("events")
  # Set explicit width on the clone
  currentWidth = $(this).width()
  return $(this).clone().width(currentWidth)

dragProps =
  addClasses: false
  # cancel: ".data-text"
  # containment: "window"
  cursorAt: { top: 0, left: 0 }
  distance: 5
  handle: ".label" # the header
  helper: dragHelper
  revert: "invalid"
  scroll: false
  # Make it really obvious where to drop these
  start: Mapper.highlightEvents
  stop: Mapper.unhighlightEvents
  zIndex: 1000

Template.dataItem.rendered = ->
  # Only visible elements are rendered in the #each helper so no optimization to do here
  $(@firstNode).draggable dragProps

Template.dataItem.events =
  "click .data-cell": (e, t) -> Mapper.selectData(@_id)


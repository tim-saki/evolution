WORLD_WIDTH = 100
WORLD_HEIGHT = 30
DISP_EMPTY = "."

world = []

$ = (id) ->
  document.getElementById id

skip_day = ->
  console.log "skip day"
  update_world()
  draw_world()

update_world = ->

draw_world = ->
  ary = []
  for y in [0...WORLD_HEIGHT]
    for x in [0...WORLD_WIDTH]
      ary.push(DISP_EMPTY) if world[[x, y]] is undefined
    ary.push("\n")
  $("world").innerHTML = ary.join('')

window.onload = ->
  console.log "loaded"
  draw_world()
  $("simulate_btn").addEventListener "click", skip_day

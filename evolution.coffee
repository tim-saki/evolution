WORLD_WIDTH = 100
WORLD_HEIGHT = 30
DISP_EMPTY = "."
DISP_PLANT = "*"

world = []
plants = []

$ = (id) ->
  document.getElementById id

skip_day = ->
  console.log "skip day"
  update_world()
  draw_world()

update_world = ->
  add_plants()

draw_world = ->
  ary = []
  for y in [0...WORLD_HEIGHT]
    for x in [0...WORLD_WIDTH]
      switch world[[x, y]]
        when "plant" then ary.push(DISP_PLANT)
        else ary.push(DISP_EMPTY)
    ary.push("\n")
  $("world").innerHTML = ary.join('')

random_int = (min, max) ->
  min + Math.floor(Math.random() * max)

add_plants = ->
  pos = {x: random_int(0, WORLD_WIDTH), y: random_int(0, WORLD_HEIGHT)}
  world[[pos.x, pos.y]] = "plant"

window.onload = ->
  console.log "loaded"
  draw_world()
  $("simulate_btn").addEventListener "click", skip_day

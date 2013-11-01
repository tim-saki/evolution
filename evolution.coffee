WORLD_WIDTH = 100
WORLD_HEIGHT = 30
JUNGLE =
  x: 45
  y: 10
  width: 10
  height: 10
DISP_EMPTY = " "
DISP_PLANT = "*"
DISP_ANIMAL = "M"

world = []
plants = []
animals = []

$ = (id) ->
  document.getElementById id

skip_day = ->
  console.log "skip day"
  update_world()
  draw_world()

update_world = ->
  add_plants()
  for animal in animals
    animal.move()

draw_world = ->
  world = []
  for y in [0...WORLD_HEIGHT]
    for x in [0...WORLD_WIDTH]
      if plants[[x, y]]
        world[[x, y]] = "plant"
  for animal in animals
    world[[animal.x, animal.y]] = "animal"
  ary = []
  for y in [0...WORLD_HEIGHT]
    for x in [0...WORLD_WIDTH]
      switch world[[x, y]]
        when "animal" then ary.push(DISP_ANIMAL)
        when "plant" then ary.push(DISP_PLANT)
        else ary.push(DISP_EMPTY)
    ary.push("\n")
  $("world").innerHTML = ary.join('')

random_int = (min, max) ->
  min + Math.floor(Math.random() * max)

add_plants = ->
  pos =
    x: random_int(0, WORLD_WIDTH)
    y: random_int(0, WORLD_HEIGHT)
  plants[[pos.x, pos.y]] = true
  pos =
    x: random_int(JUNGLE.x, JUNGLE.width)
    y: random_int(JUNGLE.y, JUNGLE.height)
  plants[[pos.x, pos.y]] = true

dist_x_by_dir =
  0: -1
  1: 0
  2: 1
  3: 1
  4: 1
  5: 0
  6: -1
  7: -1
dist_y_by_dir =
  0: -1
  1: -1
  2: -1
  3: 0
  4: 1
  5: 1
  6: 1
  7: 0

class Animal
  constructor: (@x, @y, @direction) ->
  move: ->
    @x += dist_x_by_dir[@direction]
    @y += dist_y_by_dir[@direction]
    if @x < 0 then @x += WORLD_WIDTH
    if WORLD_WIDTH <= @x then @x -= WORLD_WIDTH
    if @y < 0 then @y += WORLD_HEIGHT
    if WORLD_HEIGHT <= @y then @y -= WORLD_HEIGHT

window.onload = ->
  console.log "loaded"
  animals.push(new Animal(50, 15, 0))
  draw_world()
  $("simulate_btn").addEventListener "click", skip_day

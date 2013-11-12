WORLD_WIDTH = 100
WORLD_HEIGHT = 30
JUNGLE =
  x: 45
  y: 10
  width: 10
  height: 10
ENERGY = 200
ENERGY_GAIN = 80
REPRODUCE_THLD = 200
DEATH_THLD = 0
DANGER_THLD = 80
DISP_EMPTY = " "
DISP_PLANT = "<span style='color: blue;'>*</span>"
DISP_ANIMAL = "<span style='color: green;'>M︎</span>"
DISP_ANIMAL_DANGER = "<span style='color: red;'>M︎</span>"
TIMER = undefined

plants = []
animals = []

$ = (id) ->
  document.getElementById id

class Simulator
  constructor: (
    @input_days
    @input_interval
    @simulate_btn
    @input_auto
  ) ->
    @add_events()
    @draw_world()

  skip_day: (days) ->
    @update_world() for i in [0...days]
    @draw_world()

  update_world: ->
    @add_plants()
    for animal in animals when animal?
      if animal.energy <= DEATH_THLD
        animals.splice(animals.indexOf(animal), 1)
      else
        animal.eat()
        animal.turn()
        animal.move()
    animal.reproduce() for animal in animals when REPRODUCE_THLD <= animal.energy

  draw_world: ->
    world = []
    for y in [0...WORLD_HEIGHT]
      for x in [0...WORLD_WIDTH]
        world[[x, y]] = "plant" if plants[[x, y]]
    for animal in animals
      world[[animal.x, animal.y]] = "animal_danger" if animal.energy <= DANGER_THLD
      world[[animal.x, animal.y]] = "animal" if DANGER_THLD < animal.energy

    ary = []
    for y in [0...WORLD_HEIGHT]
      for x in [0...WORLD_WIDTH]
        switch world[[x, y]]
          when "animal" then ary.push(DISP_ANIMAL)
          when "animal_danger" then ary.push(DISP_ANIMAL_DANGER)
          when "plant" then ary.push(DISP_PLANT)
          else ary.push(DISP_EMPTY)
      ary.push("\n")
    $("world").innerHTML = ary.join('')

  add_plants: ->
    pos =
      x: random_int(0, WORLD_WIDTH)
      y: random_int(0, WORLD_HEIGHT)
    plants[[pos.x, pos.y]] = true
    pos =
      x: random_int(JUNGLE.x, JUNGLE.x + JUNGLE.width)
      y: random_int(JUNGLE.y, JUNGLE.y + JUNGLE.height)
    plants[[pos.x, pos.y]] = true

  auto_simulate_handler: ->
    if $("input_auto").checked
      TIMER = setInterval (=> @skip_day(@input_days.value)), $("input_interval").value
    else
      clearInterval TIMER

  add_events: ->
    @simulate_btn.addEventListener "click", (e) =>
      @skip_day @input_days.value
    @input_auto.addEventListener "change", (e) =>
      @auto_simulate_handler()

random_int = (min, max) ->
  min + Math.floor(Math.random() * (max - min))

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

sum_array = (ary) ->
  sum = 0
  sum += a for a in ary
  sum

class Animal
  constructor: (@x, @y, @direction, @genes, @energy) ->
  move: ->
    @x += dist_x_by_dir[@direction]
    @y += dist_y_by_dir[@direction]
    if @x < 0 then @x += WORLD_WIDTH
    if WORLD_WIDTH <= @x then @x -= WORLD_WIDTH
    if @y < 0 then @y += WORLD_HEIGHT
    if WORLD_HEIGHT <= @y then @y -= WORLD_HEIGHT
    @energy -= 1
  turn: ->
    thresholds = []
    thresholds[i] = sum_array(@genes.slice(0, i+1)) for i in [0...8]
    rand = random_int(0, thresholds[thresholds.length - 1])
    @direction = -1
    if rand <= thresholds[0]
      @direction = 0
    else if rand <= thresholds[1]
      @direction = 1
    else if rand <= thresholds[2]
      @direction = 2
    else if rand <= thresholds[3]
      @direction = 3
    else if rand <= thresholds[4]
      @direction = 4
    else if rand <= thresholds[5]
      @direction = 5
    else if rand <= thresholds[6]
      @direction = 6
    else if rand <= thresholds[7]
      @direction = 7
  eat: ->
    if plants[[@x, @y]]
      plants[[@x, @y]] = undefined
      @energy += ENERGY_GAIN
  reproduce: ->
    @energy = Math.floor(@energy / 2)
    child_genes = @genes
    child_genes[random_int(0, 8)] += random_int(-1, 2)
    animals.push(new Animal(@x, @y, @direction, child_genes, @energy))

window.onload = ->
  first_genes = (random_int(1, 10) for i in [0...8])
  animals.push(new Animal(WORLD_WIDTH / 2, WORLD_HEIGHT / 2, 0, first_genes, ENERGY))
  new Simulator(
    $('input_days')
    $('input_interval')
    $('simulate_btn')
    $('input_auto')
  )

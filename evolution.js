// Generated by CoffeeScript 1.6.3
(function() {
  var $, Animal, DISP_ANIMAL, DISP_EMPTY, DISP_PLANT, ENERGY, JUNGLE, WORLD_HEIGHT, WORLD_WIDTH, add_plants, animals, dist_x_by_dir, dist_y_by_dir, draw_world, plants, random_int, skip_day, sum_array, update_world, world;

  WORLD_WIDTH = 100;

  WORLD_HEIGHT = 30;

  JUNGLE = {
    x: 45,
    y: 10,
    width: 10,
    height: 10
  };

  ENERGY = 200;

  DISP_EMPTY = " ";

  DISP_PLANT = "*";

  DISP_ANIMAL = "M";

  world = [];

  plants = [];

  animals = [];

  $ = function(id) {
    return document.getElementById(id);
  };

  skip_day = function() {
    console.log("skip day");
    update_world();
    return draw_world();
  };

  update_world = function() {
    var animal, _i, _j, _len, _len1, _results;
    add_plants();
    for (_i = 0, _len = animals.length; _i < _len; _i++) {
      animal = animals[_i];
      if (animal.energy <= 0) {
        animals.splice(animals.indexOf(animal), 1);
      }
      animal.eat();
      animal.turn();
      animal.move();
    }
    _results = [];
    for (_j = 0, _len1 = animals.length; _j < _len1; _j++) {
      animal = animals[_j];
      if (200 <= animal.energy) {
        _results.push(animal.reproduce());
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  draw_world = function() {
    var animal, ary, x, y, _i, _j, _k, _l, _len, _m;
    world = [];
    for (y = _i = 0; 0 <= WORLD_HEIGHT ? _i < WORLD_HEIGHT : _i > WORLD_HEIGHT; y = 0 <= WORLD_HEIGHT ? ++_i : --_i) {
      for (x = _j = 0; 0 <= WORLD_WIDTH ? _j < WORLD_WIDTH : _j > WORLD_WIDTH; x = 0 <= WORLD_WIDTH ? ++_j : --_j) {
        if (plants[[x, y]]) {
          world[[x, y]] = "plant";
        }
      }
    }
    for (_k = 0, _len = animals.length; _k < _len; _k++) {
      animal = animals[_k];
      world[[animal.x, animal.y]] = "animal";
    }
    ary = [];
    for (y = _l = 0; 0 <= WORLD_HEIGHT ? _l < WORLD_HEIGHT : _l > WORLD_HEIGHT; y = 0 <= WORLD_HEIGHT ? ++_l : --_l) {
      for (x = _m = 0; 0 <= WORLD_WIDTH ? _m < WORLD_WIDTH : _m > WORLD_WIDTH; x = 0 <= WORLD_WIDTH ? ++_m : --_m) {
        switch (world[[x, y]]) {
          case "animal":
            ary.push(DISP_ANIMAL);
            break;
          case "plant":
            ary.push(DISP_PLANT);
            break;
          default:
            ary.push(DISP_EMPTY);
        }
      }
      ary.push("\n");
    }
    return $("world").innerHTML = ary.join('');
  };

  random_int = function(min, max) {
    return min + Math.floor(Math.random() * (max - min));
  };

  add_plants = function() {
    var pos;
    pos = {
      x: random_int(0, WORLD_WIDTH),
      y: random_int(0, WORLD_HEIGHT)
    };
    plants[[pos.x, pos.y]] = true;
    pos = {
      x: random_int(JUNGLE.x, JUNGLE.x + JUNGLE.width),
      y: random_int(JUNGLE.y, JUNGLE.y + JUNGLE.height)
    };
    return plants[[pos.x, pos.y]] = true;
  };

  dist_x_by_dir = {
    0: -1,
    1: 0,
    2: 1,
    3: 1,
    4: 1,
    5: 0,
    6: -1,
    7: -1
  };

  dist_y_by_dir = {
    0: -1,
    1: -1,
    2: -1,
    3: 0,
    4: 1,
    5: 1,
    6: 1,
    7: 0
  };

  sum_array = function(ary) {
    var a, sum, _i, _len;
    sum = 0;
    for (_i = 0, _len = ary.length; _i < _len; _i++) {
      a = ary[_i];
      sum += a;
    }
    return sum;
  };

  Animal = (function() {
    function Animal(x, y, direction, genes, energy) {
      this.x = x;
      this.y = y;
      this.direction = direction;
      this.genes = genes;
      this.energy = energy;
    }

    Animal.prototype.move = function() {
      this.x += dist_x_by_dir[this.direction];
      this.y += dist_y_by_dir[this.direction];
      if (this.x < 0) {
        this.x += WORLD_WIDTH;
      }
      if (WORLD_WIDTH <= this.x) {
        this.x -= WORLD_WIDTH;
      }
      if (this.y < 0) {
        this.y += WORLD_HEIGHT;
      }
      if (WORLD_HEIGHT <= this.y) {
        this.y -= WORLD_HEIGHT;
      }
      return this.energy -= 1;
    };

    Animal.prototype.turn = function() {
      var i, rand, thresholds, _i;
      thresholds = [];
      for (i = _i = 0; _i < 8; i = ++_i) {
        thresholds[i] = sum_array(this.genes.slice(0, i + 1));
      }
      rand = random_int(0, thresholds[thresholds.length - 1]);
      this.direction = -1;
      if (rand <= thresholds[0]) {
        return this.direction = 0;
      } else if (rand <= thresholds[1]) {
        return this.direction = 1;
      } else if (rand <= thresholds[2]) {
        return this.direction = 2;
      } else if (rand <= thresholds[3]) {
        return this.direction = 3;
      } else if (rand <= thresholds[4]) {
        return this.direction = 4;
      } else if (rand <= thresholds[5]) {
        return this.direction = 5;
      } else if (rand <= thresholds[6]) {
        return this.direction = 6;
      } else if (rand <= thresholds[7]) {
        return this.direction = 7;
      }
    };

    Animal.prototype.eat = function() {
      if (plants[[this.x, this.y]]) {
        plants[[this.x, this.y]] = void 0;
        return this.energy += 80;
      }
    };

    Animal.prototype.reproduce = function() {
      var child_genes;
      this.energy = this.energy / 2;
      child_genes = this.genes;
      child_genes[random_int(0, 8)] += random_int(-1, 2);
      return animals.push(new Animal(this.x, this.y, this.direction, child_genes, this.energy));
    };

    return Animal;

  })();

  window.onload = function() {
    var first_genes, i;
    console.log("loaded");
    first_genes = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 0; _i < 8; i = ++_i) {
        _results.push(random_int(1, 10));
      }
      return _results;
    })();
    animals.push(new Animal(50, 15, 0, first_genes, ENERGY));
    draw_world();
    return $("simulate_btn").addEventListener("click", skip_day);
  };

}).call(this);

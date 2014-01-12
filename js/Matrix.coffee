Sylvester = require("./vendor/sylvester-0.2.0.js")
$V = Sylvester.Vector
$M = Sylvester.Matrix

class Matrix
  constructor: (array)->
    @matrix = $M.create([
      [array[0][0], array[0][1], array[0][2]],
      [array[1][0], array[1][1], array[1][2]],
      [array[2][0], array[2][1], array[2][2]],
    ])

class Vector
  @fromVector: (vector)->
    new Vector([ vector.e(1), vector.e(2), vector.e(3) ])

  constructor: (array)->
    @vector = $V.create(array)

  norm: =>
    unit  = @vector.toUnitVector()
    new Vector([ unit.e(1), unit.e(2), unit.e(3) ])

  toArray: =>
    [ @vector.e(1), @vector.e(2), @vector.e(3) ]

class ScaleMatrix
  constructor: (array)->
    @vector = new Vector(array)
    @unit   = @vector.norm()
    @scale  = @vector.vector.dot(@unit.vector)
    @matrix = $M.create([
      [1/@scale, 0, 0],
      [0, 1/@scale, 0],
      [0, 0, 1/@scale],
    ])

  scaled: (array)=>
    vector = new Vector(array)
    scaled = @matrix.x(vector.vector)
    Vector.fromVector(scaled).toArray()

module.exports = {Vector: Vector, Matrix: Matrix, ScaleMatrix: ScaleMatrix}

SPEED = 2
SIZE  = 200

sketchProc = (P) ->

  P.setup = ->
    P.size(600, 600, P.WEBGL)

  xRotation = 5 * Math.PI / 180
  yRotation = 5 * Math.PI / 180
  zRotation = 5 * Math.PI / 180

  P.draw = ->
    P.background(224)
    P.lights()

    P.translate(P.width/2.0, P.height/2.0)

    P.rotateX xRotation
    P.rotateY yRotation
    P.rotateZ zRotation

    P.rotateX P.mouseX / 10 * Math.PI / 180
    P.rotateY P.mouseY / 10 * Math.PI / 180
    P.rotateZ (P.mouseX + P.mouseY) / 10 * Math.PI / 180

    P.stroke(50, 50, 50)
    P.line(-SIZE,     0,     0, SIZE,    0,   0)
    P.line(    0, -SIZE,     0,    0, SIZE,   0)
    P.line(    0,     0, -SIZE,    0,    0, SIZE)

    P.noStroke()
    P.fill 166, 244, 130
    DATA.forEach (position)->
      P.translate(position...)
      P.sphere(2)

  P.keyPressed = ->
    switch P.key.toString()
      when "x" then xRotation += SPEED * Math.PI / 180
      when "X" then xRotation -= SPEED * Math.PI / 180
      when "y" then yRotation += SPEED * Math.PI / 180
      when "Y" then yRotation -= SPEED * Math.PI / 180
      when "z" then zRotation += SPEED * Math.PI / 180
      when "Z" then zRotation -= SPEED * Math.PI / 180

# attaching the sketchProc function to the canvas
canvas = document.getElementById("canvas")
processingInstance = new Processing(canvas, sketchProc)

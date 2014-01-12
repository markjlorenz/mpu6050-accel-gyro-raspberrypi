connect         = require("connect")
app             = connect()
                   .use(connect.static("vendor"))
                   .use(connect.static("public"))
server          = app.listen process.env.port || 3000
io              = require("socket.io").listen(server)
fs              = require("fs")
# PositionTracker = require("../reader-js/PositionTracker")
# positionTracker = new PositionTracker(5)
# positionTracker.start()

io.set "log level", 1  # debug is really noisy in this app
# io.sockets.on "connection", (socket) ->
#   positionTracker.on "data", (frame)->
#     socket.emit "update", frame.position

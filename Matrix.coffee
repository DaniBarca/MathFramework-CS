class SQMatrix
  size: 0
  m: []
  rows: 0
  cols: 0

  constructor: (n) ->
    size = n*n
    rows = n
    cols = n
    clear()

  clear: () ->
    for i in [0..size] by 1
      m[i] = 0
    return

  clone: (mb) ->
    size = mb.size
    rows = mb.rows
    cols = mb.cols
    m    = mb.getArr()
    return

  setIdentity: () ->
    clear()

    for r in [0..rows] by 1
      for c in [0..cols] by 1
        set(r,c,1)
    return

  get: (r,c) -> m[r*cols+c]

  set: (r,c,v) ->
    m[r*cols+c] = v
    return

  getArr: () -> return m

  traspose: () ->
    mb = new SQMatrix(1)
    mb.clone(this)

    for r in [0..rows] by 1
      for c in [0..cols] by 1
        set(c,r,mb.get(r,c))
    return

  mult: (mb) ->
    res = new SQMatrix(rows)
    
    temp
    for r in [0..rows] by 1
      for c in [0..cols] by 1
        temp = 0
        for t in [0..cols] by 1
          temp = get(r,t) * get(t,c)
        res.set(r,c,temp)
    res

class Matrix33 extends SQMatrix
  constructor: () ->
    size = 9
    m    = new Array(9)
    cols = 3
    rows = 3
    clear()

  ###
  This method erases previous data in Matrix
  radians: rotation angle in rads
  axis:    3 position Array with 1,0 values where:
  axis[0] => x
  axis[1] => y
  axis[2] => z
  ###
  setRotationMatrix: (radians, axis) ->
    sinr = Math.sin(radians)
    cosr = Math.cos(radians)

    aux = new Matrix33()
    if axis[0] == 1
      aux.setIdentity()
      aux.set(1,1,cosr)
      aux.set(1,2,-sinr)
      aux.set(2,1,sinr)
      aux.set(2,2, cosr)
      clone(mult(aux))
    
    if axis[1] == 1
      aux.setIdentity()
      aux.set(0,0, cosr)
      aux.set(0,2, sinr)
      aux.set(2,0,-sinr)
      aux.set(2,2, cosr)
      clone(mult(aux))
    
    if axis[2] == 1
      aux.setIdentity()
      aux.set(0,0, cosr)
      aux.set(0,1,-sinr)
      aux.set(1,0, sinr)
      aux.set(1,1, cosr)
      clone(mult(aux))
    return
    
  setRotation: (radians,axis) ->
    rm = new Matrix33()
    rm.setRotationMatrix(radians,axis)

    x = m[2]
    y = m[5]

    setIdentity()
    clone(mult(rm))

    m[2] = x
    m[5] = x
    return

  rotate: (radians,axis) ->
    rm = new Matrix33()
    rm.setRotationMatrix(radians,axis)
    clone(mult(rm))
    return
  
  ###
  For a local rotation:
  1: Put the Matrix at 0,0 coordinates
  2: Rotate the matrix normally
  3: Reset previous position
  ###
  rotateLocal: (radians,axis) ->
    x = m[2]
    y = m[5]

    setPosition(0,0)
    rotate(radians,axis)
    setPosition(x,y)
    return

  setTranslationMatrix: (x,y) ->
    setIdentity()
    setPosition(x,y)
    return

  setPosition: (x,y) ->
    m[2] = x
    m[5] = y
    return

  ###
  Be sure to understand the difference between translate and translateLocal
  before touching anything. It's important.
  ###
  translateLocal: (x,y) ->
    t = new Matrix33()
    t.setTranslationMatrix(x,y)
    clone(mult(t))
    return

  translate: (x,y) ->
    m[2] += x
    m[5] += y
    return
  
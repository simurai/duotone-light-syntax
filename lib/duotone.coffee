chroma = require 'chroma-js'

root = document.documentElement
uno = ''
duo = ''

module.exports =
  activate: (state) ->
    uno = atom.config.get('duotone-light-syntax.color.uno').toHexString()
    duo = atom.config.get('duotone-light-syntax.color.duo').toHexString()
    setColors()

    # Change Uno
    atom.config.onDidChange 'duotone-light-syntax.color.uno', ({newValue, oldValue}) ->
      uno = newValue.toHexString()
      setColors()

    # Change Duo
    atom.config.onDidChange 'duotone-light-syntax.color.duo', ({newValue, oldValue}) ->
      duo = newValue.toHexString()
      setColors()

  deactivate: ->
    unsetColors()

# Apply Colors -----------------------
setColors = ->
  unsetColors() # prevents adding endless properties

  # Color mixing
  _unoHigh = chroma.mix( uno, 'hsl(30, 0%, 0%)', 0.3);   # mix with black
  _unoMid  = uno                                         # set by user
  _unoLow  = chroma.mix( uno, 'hsl(30, 16%, 98%)', 0.6); # mix with background (@syntax-bg)

  _duoHigh = chroma.mix( duo, 'hsl(30, 0%, 0%)', 0.5);   # mix with black
  _duoMid  = duo                                         # set by user
  _duoLow  = chroma.mix( duo, 'hsl(30, 16%, 98%)', 0.6); # mix with background (@syntax-bg)

  # Color scales
  _scaleUno = chroma.scale([_unoHigh, _unoMid, _unoLow]).colors(5)
  _scaleDuo = chroma.scale([_duoHigh, _duoMid, _duoLow]).colors(5) # only 2,3,4 will get used

  root.style.setProperty('--uno-1', _scaleUno[0])
  root.style.setProperty('--uno-2', _scaleUno[1])
  root.style.setProperty('--uno-3', _scaleUno[2]) # <- set by user
  root.style.setProperty('--uno-4', _scaleUno[3])
  root.style.setProperty('--uno-5', _scaleUno[4])

  root.style.setProperty('--duo-1', _scaleDuo[1])
  root.style.setProperty('--duo-2', _scaleDuo[2]) # <- set by user
  root.style.setProperty('--duo-3', _scaleDuo[3])

  root.style.setProperty('--accent', _scaleDuo[1])


# Unset Colors -----------------------
unsetColors = ->
  root.style.removeProperty('--uno-1')
  root.style.removeProperty('--uno-2')
  root.style.removeProperty('--uno-3')
  root.style.removeProperty('--uno-4')
  root.style.removeProperty('--uno-5')

  root.style.removeProperty('--duo-1')
  root.style.removeProperty('--duo-2')
  root.style.removeProperty('--duo-3')

  root.style.removeProperty('--accent')

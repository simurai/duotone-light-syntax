chroma = require 'chroma-js'

root = document.documentElement
uno = ''
duo = ''

module.exports =
  activate: (state) ->

    # Change Preset
    atom.config.observe 'duotone-light-syntax.preset', (newValue) ->
      root.classList.remove('theme-duotone-light-syntax--custom-colors')
      switch newValue
        when "Light I"
          uno = 'hsl(35, 37%, 50%)'
          duo = 'hsl(240, 49%, 68%)'
        when "Light II"
          uno = 'hsl(210, 32%, 56%)'
          duo = 'hsl(150, 62%, 53%)'
        when "Light III"
          uno = 'hsl(183, 31%, 50%)'
          duo = 'hsl( 26, 68%, 60%)'
        when "Custom"
          root.classList.add('theme-duotone-light-syntax--custom-colors')
          uno = atom.config.get('duotone-light-syntax.unoColor').toHexString()
          duo = atom.config.get('duotone-light-syntax.duoColor').toHexString()
      setColors()

    # Change Uno
    atom.config.onDidChange 'duotone-light-syntax.unoColor', ({newValue, oldValue}) ->
      uno = newValue.toHexString()
      setColors()

    # Change Duo
    atom.config.onDidChange 'duotone-light-syntax.duoColor', ({newValue, oldValue}) ->
      duo = newValue.toHexString()
      setColors()

  deactivate: ->
    root.classList.remove('theme-duotone-light-syntax--custom-colors')
    unsetColors()

# Apply Colors -----------------------
setColors = ->
  unsetColors() # prevents adding endless properties

  # Color mixing
  _unoHigh = chroma.mix( uno, 'hsl(30, 0%, 0%)', 0.8);   # mix with black
  _unoMid  = uno                                         # set by user
  _unoLow  = chroma.mix( uno, 'hsl(30, 16%, 98%)', 0.6); # mix with background (@syntax-bg)

  _duoHigh = chroma.mix( uno, 'hsl(30, 0%, 0%)', 0.6);   # mix with black
  _duoMid  = duo                                         # set by user
  _duoLow  = chroma.mix( duo, 'hsl(30, 16%, 98%)', 0.8); # mix with background (@syntax-bg)

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

  root.style.setProperty('--accent', duo)


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

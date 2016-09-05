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
        when "Light Winter"
          uno = 'hsl(186, 91%, 42%)'
          duo = 'hsl(236, 72%, 53%)'
        when "Light Spring"
          uno = 'hsl(93, 57%, 55%)'
          duo = 'hsl(314, 100%, 43%)'
        when "Light Summer"
          uno = 'hsl(202, 45%, 45%)'
          duo = 'hsl(33, 100%, 45%)'
        when "Light Fall"
          uno = 'hsl(50, 59%, 48%)'
          duo = 'hsl(24, 96%, 54%)'
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

  # Color limits
  _high = chroma.mix(uno, 'hsl(0,0%,0%)', 0.5); # mix with black
  _mid  = uno
  _low  = chroma.mix(uno, 'hsl(0,0%,78%)', 0.8); # mix with light grey

  # Color scales
  _scaleUno = chroma.scale([ _high, _mid, _low]).colors(5)
  _scaleDuo = chroma.scale([ duo, _low]).padding([0, 0.33]).colors(3)

  root.style.setProperty('--uno-1', _scaleUno[0])
  root.style.setProperty('--uno-2', _scaleUno[1])
  root.style.setProperty('--uno-3', _scaleUno[2])
  root.style.setProperty('--uno-4', _scaleUno[3])
  root.style.setProperty('--uno-5', _scaleUno[4])

  root.style.setProperty('--duo-1', _scaleDuo[0])
  root.style.setProperty('--duo-2', _scaleDuo[1])
  root.style.setProperty('--duo-3', _scaleDuo[2])

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

import chroma from 'chroma-js'
import { VideoTexture, DataTexture, RGBAFormat } from 'three'
import fragmentShader from './day-27.glsl'
import view from './day-27.html'

function getPaletteTexture(palette) {
  const size = palette.length * 4;
  const data = new Uint8Array(size)
  let color

  for(let i = 0; i < size; i += 4) {
    color = chroma(palette[Math.floor(i / 4)])
    

    data[i + 0] = color.get('rgba.r')
    data[i + 1] = color.get('rgba.g')
    data[i + 2] = color.get('rgba.b')
    data[i + 3] = color.get('rgba.a')
  }

  return new DataTexture( data, palette.length, 1, RGBAFormat )
}

let _palette = chroma.scale(['white', 'black']).mode('lab').colors(5)
let paletteTexture = getPaletteTexture(_palette)

function connectPaletteToForm(palette) {
  const form = document.getElementById('palette-form')
  const colorInput = document.getElementById('color-input')
  const addColor = document.getElementById('add-color')
  const paletteContainer = document.getElementById('palette-container')

  form.addEventListener('submit', (event) => {
    event.preventDefault()
    const colors = Array.from(event.target.querySelectorAll('.color'))
      .map((el) => el.colorValue)

    _palette = colors
    paletteTexture = getPaletteTexture(colors)
  })

  addColor.addEventListener('click', () => {
    addColorEl(paletteContainer, colorInput.value)
  })

  palette.forEach((color) => {
    addColorEl(paletteContainer, color)
  })
}

function addColorEl(container, color) {
  const el = document.createElement('output')
  el.classList.add('color')
  el.colorValue = color
  el.style.background = color

  el.addEventListener('click', (event) => {
    container.removeChild(event.target)
  })

  container.appendChild(el)
}

const config = {
  name: 'Day 27',
  frag: fragmentShader,
  uniforms: {
    texture: () => {
      let video = document.getElementById('webcam-video')

      if(!video) {
        video = document.createElement('video')
        video.id = 'webcam-video'
        video.hidden = true
        video.setAttribute('autoplay', 'true')
        navigator.mediaDevices.getUserMedia({video: true}).then(function(stream) {
          video.srcObject = stream
        })
      }

      return new VideoTexture(video);
    },
    palette: () => {
      connectPaletteToForm(_palette)

      return paletteTexture
    },
    paletteWidth: _palette.length
  },
  updates: {
    palette: () => paletteTexture,
    paletteWidth: () => _palette.length
  },
  html: view
}

export default config
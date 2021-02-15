import { VideoTexture, Vector2, CanvasTexture } from 'three';
import fragmentShader from './audio-visualizer.glsl'
import view from './audio-visualizer.html'

let loading = 1
let playing = false
let videoTexture = new VideoTexture()
let videoResolution = new Vector2(1, 1)

const fftSize = 1024
const analysisCanvas = document.createElement('canvas')
const analysisContext = analysisCanvas.getContext('2d')
let dataArray
let analyser
let analysisImageData
let fftTexture = new CanvasTexture(analysisCanvas)

function initializeUI() {
  const fileEl = document.getElementById('fileEl')
  fileEl.addEventListener('change', loadFile)

  const playToggleEl = document.getElementById('playToggleEl')
  playToggleEl.addEventListener('click', togglePlay)

  const videoEl = document.getElementById('visualizerSrcEl')
  videoTexture = new VideoTexture(videoEl)

  analyser = setupAnalyser(videoEl)
}

function loadFile(changeEvent) {

}

function togglePlay() {
  const videoEl = document.getElementById('visualizerSrcEl')
  const playToggleEl = document.getElementById('playToggleEl')
  playing = !playing
  playToggleEl.textContent = playing
    ? 'Stop'
    : 'Start'
  
  playing ? videoEl.play() : videoEl.pause();
}

function getVideoResolution () {
  const videoEl = document.getElementById('visualizerSrcEl')
  const {videoWidth, videoHeight} = videoEl

  videoWidth !== videoResolution.x && videoResolution.setX(videoWidth)
  videoHeight !== videoResolution.y && videoResolution.setY(videoHeight)
  
  return videoResolution
}

function setupAnalyser(videoEl) {
  let analyser
  const audioContext = new (window.AudioContext || window.webkitAudioContext)()
  const source = audioContext.createMediaElementSource(videoEl)
  analyser = audioContext.createAnalyser()

  analyser.fftSize = fftSize
  analyser.smoothingTimeConstant = 0.8
  analyser.maxDecibels = -10
  analyser.minDecibels = -90
  const bufferLength = analyser.frequencyBinCount
  dataArray = new Uint8Array(bufferLength)
  analysisCanvas.width = dataArray.length
  analysisCanvas.height = 1
  analysisImageData = new Uint8ClampedArray(bufferLength * 4)
  
  source.connect(analyser)
  analyser.connect(audioContext.destination)

  return analyser
}

function updateAnalysisCanvas(analyser) {
  analyser.getByteFrequencyData(dataArray)
  analysisImageData = analysisContext.getImageData(0, 0, dataArray.length, 1)

  let datum
  for(let i = 0; i < dataArray.length; i++) {
    datum = dataArray[i]
    analysisImageData.data[i*4 + 0] = datum
    analysisImageData.data[i*4 + 1] = datum
    analysisImageData.data[i*4 + 2] = datum
    analysisImageData.data[i*4 + 3] = datum
  }

  analysisContext.putImageData(analysisImageData, 0, 0)
  fftTexture.needsUpdate = true
}

const config = {
  name: 'Audio Visualizer',
  frag: fragmentShader,
  html: view,
  uniforms: {
    loading: () => {
      initializeUI();

      return loading
    },
    texture: () => videoTexture,
    textureResolution: getVideoResolution,
    fft: () => fftTexture,
    fftResolution: () => fftSize
  },
  updates: {
    loading: () => loading,
    textureResolution: getVideoResolution,
    fft: () => {
      updateAnalysisCanvas(analyser)
      return fftTexture
    }
  }
}

export default config
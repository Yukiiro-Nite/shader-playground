import { VideoTexture, Matrix3 } from 'three';
import fragmentShader from './day-25.glsl'
import view from './day-25.html';

let kernel = new Matrix3();

const config = {
  name: 'Kernel Filter',
  frag: fragmentShader,
  uniforms: {
    texture: () => {
      let video = document.getElementById('webcam-video')

      if(!video) {
        video = document.createElement('video')
        video.id = 'webcam-video'
        video.hidden = true
        video.setAttribute('autoplay', 'true')
        navigator.mediaDevices
          .getUserMedia({video: true})
          .then(function(stream) {
            video.srcObject = stream
          })
          .catch((error) => {
            console.log('Could not get webcam stream: ', error)
          })
      }

      return new VideoTexture(video);
    },
    kernel: () => {
      const cells = Array.from(document.querySelectorAll('.matrix-cell'))
      const values = cells.map(el => parseFloat(el.value))
      console.log(values)

      kernel.set(...values)
      console.log('after set values')

      cells.forEach(cell => {
        cell.addEventListener('input', () => {
          const values = cells.map(el => parseFloat(el.value))
          kernel.set(...values)
        })
      })

      return kernel;
    }
  },
  html: view
}

export default config
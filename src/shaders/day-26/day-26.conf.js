import { VideoTexture } from 'three';
import fragmentShader from './day-26.glsl'
import view from './day-26.html';

const config = {
  name: 'Day 26',
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
    }
  },
  html: view
}

export default config
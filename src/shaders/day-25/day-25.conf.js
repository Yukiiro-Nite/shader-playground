import { VideoTexture } from 'three';
import fragmentShader from './day-25.glsl'
import view from './day-25.html';

const config = {
  name: 'Day 25',
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
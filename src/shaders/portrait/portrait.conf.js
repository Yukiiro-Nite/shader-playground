import { Vector2 } from 'three';
import fragmentShader from './portrait.glsl'
import view from './portrait.html'
import { getWebcamVideo, getWebcamResolution } from '../utils/webcam-video';


const config = {
  name: 'Portrait',
  frag: fragmentShader,
  uniforms: {
    texture: getWebcamVideo,
    textureResolution: getWebcamResolution
  },
  updates: {
    textureResolution: getWebcamResolution
  },
  html: view,
}

export default config
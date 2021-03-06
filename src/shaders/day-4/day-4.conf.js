import { TextureLoader } from 'three';
import fragmentShader from './day-4.glsl'
import view from './day-4.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Ripple Effect',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
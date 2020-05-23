import { TextureLoader } from 'three';
import fragmentShader from './day-11.glsl'
import view from './day-11.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Hue Shift',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
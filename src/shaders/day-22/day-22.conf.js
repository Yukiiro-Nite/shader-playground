import { TextureLoader } from 'three';
import fragmentShader from './day-22.glsl'
import view from './day-22.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'RGB Desync',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
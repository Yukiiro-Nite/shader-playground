import { TextureLoader } from 'three';
import fragmentShader from './day-9.glsl'
import view from './day-9.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Day 9',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
import { TextureLoader } from 'three';
import fragmentShader from './day-10.glsl'
import view from './day-10.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Fire',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
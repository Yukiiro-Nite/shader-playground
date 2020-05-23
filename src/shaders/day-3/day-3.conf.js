import { TextureLoader } from 'three';
import fragmentShader from './day-3.glsl'
import view from './day-3.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Posterize',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
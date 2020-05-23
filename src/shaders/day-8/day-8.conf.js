import { TextureLoader } from 'three';
import fragmentShader from './day-8.glsl'
import view from './day-8.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Ellipse',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
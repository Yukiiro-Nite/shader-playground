import { TextureLoader } from 'three';
import fragmentShader from './day-2.glsl'
import view from './day-2.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Rainbow Cat',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
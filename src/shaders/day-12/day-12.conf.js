import { TextureLoader } from 'three';
import fragmentShader from './day-12.glsl'
import view from './day-12.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Bouncing Ball',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
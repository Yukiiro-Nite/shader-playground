import { TextureLoader } from 'three';
import fragmentShader from './day-6.glsl'
import view from './day-6.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
const config = {
  name: 'Image Brightness Heightmap',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture
  },
  html: view
}

export default config
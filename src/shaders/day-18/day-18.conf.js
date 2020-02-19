import { TextureLoader, Color } from 'three';
import fragmentShader from './day-18.glsl'
import view from './day-18.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/256/256');
let color = new Color();
const config = {
  name: 'Day 18',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture,
    inputColor: () => {
      const colorEl = document.getElementById('colorEl');
      color = new Color(colorEl.value);

      colorEl.addEventListener('change', (event) => {
        color = new Color(event.target.value);
      })
    }
  },
  updates: {
    inputColor: () => color
  },
  html: view
}

export default config
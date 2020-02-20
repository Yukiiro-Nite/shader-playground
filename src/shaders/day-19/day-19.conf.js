import { TextureLoader, Vector2 } from 'three';
import fragmentShader from './day-19.glsl'
import view from './day-19.html';

const defaultTexture = new TextureLoader().load('https://placekitten.com/512/512');
let position = new Vector2(0.5, 0.5);
let direction = 0;
const config = {
  name: 'Day 19',
  frag: fragmentShader,
  uniforms: {
    texture: defaultTexture,
    inputPosition: () => {
      const xEl = document.getElementById('xEl');
      const yEl = document.getElementById('yEl');
      position = new Vector2(xEl.value, yEl.value);

      xEl.addEventListener('input', (event) => {
        position.setX(event.target.value);
      })
      yEl.addEventListener('input', (event) => {
        position.setY(event.target.value);
      })
    },
    inputDirection: () => {
      const directionEl = document.getElementById('directionEl');
      direction = directionEl.value;

      directionEl.addEventListener('input', (event) => {
        direction = event.target.value;
      })
    }
  },
  updates: {
    inputPosition: () => position,
    inputDirection: () => direction
  },
  html: view
}

export default config
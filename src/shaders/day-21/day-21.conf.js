import fragmentShader from './day-21.glsl'
import view from './day-21.html';

let width = 1;
let height = 1;

const config = {
  name: 'Day 21',
  frag: fragmentShader,
  uniforms: {
    inputWidth: () => {
      const widthEl = document.getElementById('widthEl');
      width = widthEl.value;

      widthEl.addEventListener('input', (event) => {
        width = event.target.value;
      });
    },
    inputHeight: () => {
      const heightEl = document.getElementById('heightEl');
      height = heightEl.value;

      heightEl.addEventListener('input', (event) => {
        height = event.target.value;
      });
    },
  },
  updates: {
    inputWidth: () => width,
    inputHeight: () => height
  },
  html: view
}

export default config
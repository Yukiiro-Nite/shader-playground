import fragmentShader from './day-21.glsl'
import view from './day-21.html';

let width = 1;
let height = 1;
let isPolar = 0;
let isDistance = 0;

const config = {
  name: 'Dot Grid',
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
    isPolar: () => {
      const polarEl = document.getElementById('polarEl');
      isPolar = +(polarEl.checked);

      polarEl.addEventListener('change', (event) => {
        isPolar = +(event.target.checked);
      })
    },
    isDistance: () => {
      const distanceEl = document.getElementById('distanceEl');
      isDistance = +(distanceEl.checked);

      distanceEl.addEventListener('change', (event) => {
        isDistance = +(event.target.checked);
      })
    }
  },
  updates: {
    inputWidth: () => width,
    inputHeight: () => height,
    isPolar: () => isPolar,
    isDistance: () => isDistance,
  },
  html: view
}

export default config

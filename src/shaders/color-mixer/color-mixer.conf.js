import { Color } from 'three';
import fragmentShader from './color-mixer.glsl'
import view from './color-mixer.html'

let leftColor = new Color('#000000')
let rightColor = new Color('#ffffff')

const config = {
  name: 'Color Mixer',
  frag: fragmentShader,
  uniforms: {
    leftColor: () => {
      const leftColorEl = document.getElementById('leftColorEl');
      leftColor = new Color(leftColorEl.value);

      leftColorEl.addEventListener('input', (event) => {
        leftColor = new Color(event.target.value);
      });

      return leftColor
    },
    rightColor: () => {
      const rightColorEl = document.getElementById('rightColorEl');
      rightColor = new Color(rightColorEl.value);

      rightColorEl.addEventListener('input', (event) => {
        rightColor = new Color(event.target.value);
      });

      return rightColor;
    }
  },
  updates: {
    leftColor: () => leftColor,
    rightColor: () => rightColor
  },
  html: view
}

export default config
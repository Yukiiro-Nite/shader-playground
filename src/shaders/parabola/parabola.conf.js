import fragmentShader from './parabola.glsl'
import view from './parabola.html';
import { Vector4 } from 'three';

const config = {
  name: 'Parabola',
  frag: fragmentShader,
  uniforms: {
    fillColor: new Vector4(0.53, 0, 0, 0.5),
    strokeColor: new Vector4(1.0, 0.55, 0.20, 1.0),
    strokeWidth: 0.01
  },
  html: view
}

export default config
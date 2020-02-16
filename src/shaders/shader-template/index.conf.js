import { Vector2 } from 'three';
import fragmentShader from './fragment.glsl'
import vertexShader from './vertex.glsl'
import view from './index.html'


const vec2 = new Vector2()
const config = {
  name: 'Shader Template',
  vert: vertexShader,
  frag: fragmentShader,
  uniforms: {
    resolution: ({ renderer }) => renderer.getSize(vec2)
  },
  updates: {
    resolution: ({ renderer }) => renderer.getSize(vec2)
  },
  html: view,
  containerId: 'container'
}

export default config
import { TextureLoader, Vector2, CanvasTexture } from 'three';
import fragmentShader from './day-15-frag.glsl'
import view from './day-15-view.html'
import defaultImage from './default.png'

// I probably need to use postprocessing to make this work
// https://threejs.org/docs/#manual/en/introduction/How-to-use-post-processing

const start = new Vector2(0, 0);
const defaultTexture = new TextureLoader().load(defaultImage);
let texture;

const getSelf = ({ renderer }) => {
  texture = new CanvasTexture(renderer.domElement);
  return texture;

  // renderer.copyFramebufferToTexture(start, defaultTexture);
  // return defaultTexture;

  // const target = renderer.getRenderTarget()
  // return target
  //   ? target.texture
  //   : defaultTexture;
};

const config = {
  name: 'Phosphor',
  frag: fragmentShader,
  uniforms: {
    prevTexture: getSelf
  },
  updates: {
    prevTexture: () => {
      texture.needsUpdate = true;
      return texture;
    }
  },
  html: view,
  containerId: 'shader'
}

export default config
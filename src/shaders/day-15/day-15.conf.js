import { TextureLoader, Vector2, CanvasTexture } from 'three';
import fragmentShader from './day-15-frag.glsl'
import view from './day-15-view.html'
import defaultImage from './default.png'

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
  name: 'Day 15',
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
import * as THREE from 'three';
import defaultVertexShader from './defaultVertexShader.glsl';
import defaultFragmentShader from './defaultFragmentShader.glsl';
import defaultView from './defaultView.html';

const vec2 = new THREE.Vector2()
const defaultUniforms = {
  time: 1.0,
  resolution: ({ renderer }) => renderer.getSize(vec2)
}

const defaultUniformUpdates = {
  time: ({ timestamp }) => timestamp / 1000,
  resolution: ({ renderer }) => renderer.getSize(vec2)
}

const defaultGeometry = new THREE.PlaneBufferGeometry(2, 2);

function resolveUniforms({uniforms, renderer}) {
  return Object.entries(uniforms)
    .map(([key, uniform]) => ([
      key,
      new THREE.Uniform(
        uniform instanceof Function
          ? uniform({ renderer })
          : uniform
      )
    ]))
    .reduce((acc, [key, uniform]) => {
      acc[key] = uniform
      return acc
    }, {})
}

function updateUniforms({updates = {}, prevUniforms = {}, renderer, timestamp}) {
  return Object.entries(updates)
    .forEach(([key, update]) => {
        const newVal = update instanceof Function
          ? update({
            prev: prevUniforms[key],
            renderer,
            timestamp
          })
          : update
        if(prevUniforms[key] === undefined) {
          prevUniforms[key] = new THREE.Uniform(newVal)
        } else {
          prevUniforms[key].value = newVal 
        }
    })
}

class ShaderPage extends HTMLElement {
  get shaderConfig() {
    return this.config
  }

  set shaderConfig(conf) {
    this.unloadConfig()
    this.config = conf
    this.loadConfig()
  }

  constructor() {
    super();

    this.animate = this.animate.bind(this);
  }

  connectedCallback() { }

  attributeChangeCallback() { }

  disconnectedCallback() {
    this.unloadConfig()
  }

  loadConfig() {
    this.innerHTML = (this.config && this.config.html) || defaultView;
    this.shaderContainerId = (this.config && this.config.containerId) || 'shader-container'

    this.container = document.getElementById(this.shaderContainerId);
    this.camera = new THREE.OrthographicCamera(- 1, 1, 1, - 1, 0, 1);
    this.scene = new THREE.Scene();
    this.renderer = new THREE.WebGLRenderer();
    this.renderer.setPixelRatio(window.devicePixelRatio);
    this.renderer.setSize(512, 512);
    const geometry = (this.config && this.config.geometry) || defaultGeometry;

    this.uniforms = resolveUniforms({
      uniforms: {
        ...defaultUniforms,
        ...((this.config && this.config.uniforms) || {})
      },
      renderer: this.renderer
    })

    const material = new THREE.ShaderMaterial({
      uniforms: this.uniforms,
      vertexShader: (this.config && this.config.vert || defaultVertexShader),
      fragmentShader: (this.config && this.config.frag || defaultFragmentShader)
    });

    const mesh = new THREE.Mesh(geometry, material);
    this.scene.add( mesh );

    this.container.appendChild(this.renderer.domElement);
    this.startAnimation();
  }

  unloadConfig() {
    this.stopAnimation();

    if(this.container) {
      this.container.removeChild(this.renderer.domElement);
      // probably need to remove more things here to prevent memory leaks
    }
  }

  startAnimation() {
    this.drawing = true;
    requestAnimationFrame(this.animate);
  }

  animate(timestamp) {
    if(!this.drawing) return;

    updateUniforms({
      updates: {
        ...defaultUniformUpdates,
        ...((this.config && this.config.updates) || {})
      },
      prevUniforms: this.uniforms,
      renderer: this.renderer,
      timestamp
    });
  
    this.renderer.render(this.scene, this.camera);
    requestAnimationFrame(this.animate);
  }

  stopAnimation() {
    this.drawing = false;
  }
}

customElements.define('shader-page', ShaderPage);

export default ShaderPage;
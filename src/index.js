import * as THREE from 'three';
import shaderTemplate from './shaders/day-14';

let container;
let camera, scene, renderer;
let uniforms;

const defaultUniforms = {
  time: 1.0
}

const defaultUniformUpdates = {
  time: ({ timestamp }) => timestamp / 1000
}

init(shaderTemplate);
animate();

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

function init(shaderConfig) {
  container = document.getElementById( 'container' );
  camera = new THREE.OrthographicCamera( - 1, 1, 1, - 1, 0, 1 );
  scene = new THREE.Scene();
  renderer = new THREE.WebGLRenderer();
  renderer.setPixelRatio( window.devicePixelRatio );
  renderer.setSize(256, 256);
  var geometry = new THREE.PlaneBufferGeometry( 2, 2 );

  uniforms = resolveUniforms({
    uniforms: {
      ...defaultUniforms,
      ...shaderConfig.uniforms
    },
    renderer
  })

  var material = new THREE.ShaderMaterial( {
    uniforms: uniforms,
    vertexShader: shaderConfig.vert,
    fragmentShader: shaderConfig.frag
  } );

  var mesh = new THREE.Mesh( geometry, material );
  scene.add( mesh );

  container.appendChild( renderer.domElement );
}

function animate( timestamp ) {

  requestAnimationFrame( animate );

  updateUniforms({
    updates: {
      ...defaultUniformUpdates,
      ...shaderTemplate.updates
    },
    prevUniforms: uniforms,
    renderer,
    timestamp
  })

  renderer.render( scene, camera );

}
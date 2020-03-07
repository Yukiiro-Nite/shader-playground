# **`*.config.js` export format**

This file will be loaded automatically by the [`src/index.js`](../../../src/index.js) file. When the shader is selected in the web page, it will be loaded by the [ShaderPage](../../../src/components/ShaderPage/ShaderPage.js) component. The config file should export an object that defines your shader, what to display with it, and how to send information to it. See [`src/shaders/shader-template/index.conf.js`](index.conf.js) for an example config file.

## **Options**
### **name** [String] (Required)
Used as the name displayed inside of the select on the webpage.

```js
export default {
  name: 'Shader Name'
}
```

### **vert** [String] (Optional)
The string value of the vertex shader. Defaults to [src/components/ShaderPage/defaultVertexShader.glsl](../../../src/components/ShaderPage/defaultVertexShader.glsl). You can import shaders at the top of the config file thanks to [webpack-glsl-loader](https://github.com/grieve/webpack-glsl-loader).
```js
import vertexShader from './vertex.glsl'

export default {
  name: 'Shader Name',
  vert: vertexShader
}
```

### **frag** [String] (Optional)
The string value of the fragment shader. Defaults to [src/components/ShaderPage/defaultFragmentShader.glsl](../../../src/components/ShaderPage/defaultFragmentShader.glsl). You can import shaders at the top of the config file thanks to [webpack-glsl-loader](https://github.com/grieve/webpack-glsl-loader).
```js
import fragmentShader from './fragment.glsl'

export default {
  name: 'Shader Name',
  frag: fragmentShader
}
```

### **uniforms** [Object] (Optional)
The keys are used for the uniform names. The values should be something that can be converted to [Uniform](https://threejs.org/docs/index.html#api/en/core/Uniform) or a function that returns a value to be converted. The function is passed `{ renderer }`.
* `renderer` is the current [THREE.WebGLRenderer](https://threejs.org/docs/index.html#api/en/renderers/WebGLRenderer) which can be used for some kinds of dynamic uniforms.

```js
import { Vector2 } from 'three'

const vec2 = new Vector2(0, 0)
export default {
  name: 'Shader Name',
  uniform: {
    center: new Vector2(0.5, 0.5),
    resolution: ({ renderer }) =>
      renderer.getSize(vec2)
  }
}
```

### **updates** [Object] (Optional)
The keys are used to update uniforms of the same name. The values are functions that return updated values for the uniform. The function is passed `{ renderer, prev, timestamp }`.
* `renderer` is the current [THREE.WebGLRenderer](https://threejs.org/docs/index.html#api/en/renderers/WebGLRenderer).
* `prev` is the previous uniform value.
* `timestamp` is the timestamp that comes from [requestAnimationFrame](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame).

```js
import { Vector2 } from 'three'

const vec2 = new Vector2(0, 0)
export default {
  name: 'Shader Name',
  uniform: {
    position: vec2
  },
  updates: {
    position: ({ renderer, prev, timestamp }) =>
      vec2.setX(prev + 1)
  }
}
```

### **html** [String] (Optional)
The string value of the html to display when this shader config is selected. Defaults to [`src/components/ShaderPage/defaultView.html`](../../../src/components/ShaderPage/defaultView.html). You can import html at the top of the config file thanks to [html-loader]().
```js
import view from './index.html'

export default {
  name: 'Shader Name',
  html: view
}
```

### **containerId** [String] (Optional)
The String id of the container element inside of the html. Defaults to `'shader-container'`. The container element is where the renderer output is appended to the page.
```js
import view from './index.html'

export default {
  name: 'Shader Name',
  html: view,
  containerId: 'shader'
}
```

### **geometry** [[Geometry](https://threejs.org/docs/index.html#api/en/core/Geometry)] (Optional)
The [Geometry](https://threejs.org/docs/index.html#api/en/core/Geometry) that this shader is applied to. Defaults to a simple [plane](https://threejs.org/docs/index.html#api/en/geometries/PlaneBufferGeometry).

```js
import { BoxGeometry } from 'three'

export default {
  name: 'Shader Name',
  geometry: new BoxGeometry( 1, 1, 1 )
}
```
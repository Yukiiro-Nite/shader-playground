# Shader Playground
https://yukiiro-nite.github.io/shader-playground/

A project for creating and running GLSL shaders in a webpage.

## Getting Started

You will need [node.js](https://nodejs.org/en/) (LTS recommended) installed and you will need to clone the project. Once you have the project cloned, you can run the following commands:

```
npm install
npm run start
```

## Adding a shader to the playground

To add a shader to the playground, make a folder inside of [`src/shaders`](src/shaders). The [`src/shaders/shader-template`](src/shaders/shader-template) folder can also be copied instead for a quick start.

The [`src/index.js`](src/index.js) file automatically reads in all `*.config.js` files it finds inside of [`src/shaders`](src/shaders)

See [`src/shaders/shader-template/README.md`](src/shaders/shader-template/README.md) for more details on configuration.

## Built With

* [Three.js](https://threejs.org/docs/index.html#manual/en/introduction/Creating-a-scene) - Used to render the shaders
* [Webpack](https://webpack.js.org/concepts/) - Used for packaging
* [Chroma-js](https://vis4.net/chromajs/) - Used for creating an manipulating colors in javascript
* [GLSL](https://www.khronos.org/registry/OpenGL-Refpages/gl4/index.php) - The language used to build shaders

## Acknowledgments

I was inspired to write more shaders and build this playground application for myself after reading [The Book of Shaders](https://thebookofshaders.com/). I highly recommend reading it if you are also interested in learning about writing shaders.

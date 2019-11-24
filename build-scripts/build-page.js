const fs = require('fs')
const path = require('path')

const copyRecursiveSync = (src, dest) => {
  const exists = fs.existsSync(src);
  const stats = exists && fs.statSync(src);
  const isDirectory = exists && stats.isDirectory();
  if (isDirectory) {
    if(!fs.existsSync(dest)) fs.mkdirSync(dest);
    fs.readdirSync(src).forEach((childItemName) =>
      copyRecursiveSync(
        path.join(src, childItemName),
        path.join(dest, childItemName)
      )
    )
  } else {
    fs.copyFileSync(src, dest);
  }
};

const buildPage = () =>
`<html>
  <head>
    <title>Shader Playground</title>
    <style>
      body {
        min-height: 100vh;
        background-color: #16161d;
        color: #afafb9;
      }
      .glslCanvas {
        display: block;
        margin-left: auto;
        margin-right: auto;
        background-color: black;
        border: solid 2px #afafb9;
        border-radius: 4px;
      }
    </style>
    <script type="text/javascript" src="https://rawgit.com/patriciogonzalezvivo/glslCanvas/master/dist/GlslCanvas.js"></script>
  </head>
  <body>
    <h1>Shader Playground</h1>
    ${getShaderSections()}
  </body>
</html>`;

const getShaderSections = () => {
  const shaderFiles = fs.readdirSync('shaders')
  return shaderFiles
    .filter(shaderFile => shaderFile.endsWith('.glsl'))
    .map(shaderFile => `<canvas class="glslCanvas" data-fragment-url="shaders/${shaderFile}" width="256" height="256"></canvas>`)
    .join('\n')
}

const writePage = () => {
  if(!fs.existsSync('build')) fs.mkdirSync('build');
  copyRecursiveSync('shaders', 'build/shaders')
  fs.writeFileSync('build/index.html', buildPage())
}

module.exports = {
  buildPage,
  writePage
}

if(require.main === module) {
  writePage()
}
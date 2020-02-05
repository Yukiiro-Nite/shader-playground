// function provideImages() {
//   if(!window.glslCanvases) return;

//   window.glslCanvases.forEach(glslCanvas => {
//     const gl = glslCanvas.gl
//     const pixels = new Uint8Array(gl.drawingBufferWidth * gl.drawingBufferHeight * 4)
//     gl.readPixels(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight, gl.RGBA, gl.UNSIGNED_BYTE, pixels)
//     const imageData = new ImageData(gl.drawingBufferWidth, gl.drawingBufferHeight)
//     imageData.data = pixels

//     glslCanvas.loadTexture('u_self', imageData)
//   });

//   requestAnimationFrame(provideImages)
// }

// requestAnimationFrame(provideImages)
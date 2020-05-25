import { VideoTexture, Vector2 } from 'three';

let videoMeta = {}

export const getWebcamVideo = () => {
  let video = document.getElementById('webcam-video')

  if(!video) {
    video = document.createElement('video')
    video.id = 'webcam-video'
    video.hidden = true
    video.setAttribute('autoplay', 'true')

    video.addEventListener('loadedmetadata', () => {
      const {videoWidth, videoHeight} = video
      videoMeta.resolution = new Vector2(videoWidth, videoHeight)
    })

    navigator.mediaDevices
      .getUserMedia({video: true})
      .then(function(stream) {
        video.srcObject = stream
      })
      .catch((error) => {
        console.log('Could not get webcam stream: ', error)
      })
    
    document.body.appendChild(video)
  }

  return new VideoTexture(video)
}

export const getWebcamResolution = () => {
  return videoMeta.resolution
    ? videoMeta.resolution
    : new Vector2(512, 512)
}
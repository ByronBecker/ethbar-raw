import * as React from "react";
import { createChunkClient } from "./client";
import { getVideoUrl } from "./getVideoUrl";
import { LoadingPage } from "./LoadingPage";

const appClient = createChunkClient(false);

interface State {
  url: string;
  loading: boolean;
}

export default class App extends React.Component<{}, State> {
  videoRef: HTMLVideoElement = null;
  constructor(props: {}) {
    super(props)
    this.state = {
      url: null,
      loading: false,
    }
  }

  async getChunk(id: number) {
    return appClient.getRBTreeItem(id.toString())
  }

  getVideo = async (size: number) => {
    this.videoRef.muted = false;
    this.setState({loading: true});
    const videoUrl = await getVideoUrl(appClient, size)
    this.setState({url: videoUrl, loading: false})
  }
  
  handleRef = (video: any) => {
    this.videoRef = video
  }

  render() {
    
    const isSafari = navigator.userAgent.toLowerCase().indexOf('safari/') > -1;

    let autoplay = true;
    if (isSafari === true) {
      autoplay = false;
    }


    let videoStyles = "video-hidden";
    if (this.state.url !== null) {
      videoStyles = "video-shown";
      this.videoRef.play();
    }

    return (
      <div className="block">
        { this.state.url === null 
          ? <LoadingPage getVideo={this.getVideo} chunkSize={10} loading={this.state.loading}/> 
          : null 
        }
        <div className="flex-center">
          <video className={videoStyles} src={this.state.url} ref={this.handleRef} controls autoPlay muted/>
        </div>

      </div>
    )
  }
}
import * as React from 'react';
import { ScaleLoader } from 'react-spinners';
import { Howl } from 'howler';

const ON_SIGN_MINI = require('./assets/neonsign_on_mini.png');
const ON_SIGN_MOBILE = require('./assets/neonsign_on_mobile.png');
const ON_SIGN = require('./assets/neonsign_on_tablet.png');
const OFF_SIGN_MINI = require('./assets/neonsign_off_mini.png');
const OFF_SIGN_MOBILE = require('./assets/neonsign_off_mobile.png');
const OFF_SIGN = require('./assets/neonsign_off_tablet.png');
const audio_file = require('./assets/neon_lamp.mp3');

interface Props {
  getVideo: (chunkSize: number) => void;
  chunkSize: number;
  loading: boolean;
}

interface State {
  isSignOn: boolean
}

// Images with different sizes for mobile/tablet/desktop
const onImage = <picture>
  <source srcSet={ON_SIGN} media="(min-width: 1100px)"/>
  <source srcSet={ON_SIGN_MOBILE} media="(min-width: 680px)"/>
  <img src={ON_SIGN_MINI}/>
</picture>
const offImage = <picture>
  <source srcSet={OFF_SIGN} media="(min-width: 1100px)"/>
  <source srcSet={OFF_SIGN_MOBILE} media="(min-width: 680px)"/>
  <img src={OFF_SIGN_MINI} loading='lazy'/> 
</picture>

export class LoadingPage extends React.Component<Props, State> {
  audio = new Howl({
    src: [audio_file]
  });
  constructor(props: Props) {
    super(props) 
    this.state = {
      isSignOn: false
    }
  }

  componentWillUnmount(): void {
    this.audio.pause(); 
    this.audio.seek(0);
  }

  setIsSignOn(isSignOn: boolean) {
    this.setState({isSignOn})
  };

  audioTrigger(shouldPlay: boolean) {
    if (shouldPlay) {
      this.audio.mute(false);
      this.audio.volume(0.4);  // reduce audio volume so matches video volume
      this.audio.loop(true);  // loop if user continues to hover over button
      this.audio.play();
    } else {
      this.audio.mute(true);
      this.audio.pause();
      this.audio.seek(0);  // reset audio timestamp so plays from beginning
    }
  }

  render() {
    const userAgent = navigator.userAgent.toLowerCase();
    const image = this.state.isSignOn === true ? onImage : offImage;
    const buttonOrLoading = this.props.loading === true
      ? <ScaleLoader className='loader' height={50} width={6} color={'#7C002A'}/>
      : <button id='enter' type="button" 
        onClick={() => {
          this.props.getVideo(this.props.chunkSize)
        }}
        onMouseEnter={() => {
          this.setIsSignOn(true)
          this.audioTrigger(true)
        }}
        onMouseLeave={() => {
          this.setIsSignOn(false)
          this.audioTrigger(false)
        }}
      >
        Enter
      </button>
    return (
      <div>
        <div style={{display: 'none'}}>
          {onImage}
          {offImage}
        </div>
        <div className='flex-center'>
          <div className='sign-wrapper' 
          >
            {image}
          </div>
        </div>
        <div className='flex-center'>
          {buttonOrLoading}
        </div>
        <div className='flex-center' style={{marginTop: 8}}>
          <span style={{fontFamily: 'roboto'}}>Thirsty?</span>
        </div>
      </div>
    )
  }
}
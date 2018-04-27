import React, { Component } from 'react';
import {
  requireNativeComponent,
} from 'react-native';

import { navigate } from 'react-navigation';

const CameraView = requireNativeComponent('CameraView', Video);

export default class Video extends Component<{}> {
  static navigationOptions = {
    title: 'Second screen',
  };

  constructor(props) {
    super(props);
  }

  render() {
    return (<CameraView />);
  }
}


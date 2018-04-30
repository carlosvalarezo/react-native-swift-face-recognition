import React, { Component } from 'react';
import {
  requireNativeComponent,
  View,
  StatusBar
} from 'react-native';

import { navigate } from 'react-navigation';

const CameraView = requireNativeComponent('CameraView', Video);

export default class Video extends Component<{}> {
  static navigationOptions = {
    title: 'Second screen',
    header: null,
    gesturesEnabled: false,
  };

  constructor(props) {
    super(props);
  }

  goBack() {
    setTimeout(() => {
      this.props.navigation.goBack();
    }, 9000);
  }

  render() {
    return (<View onLayout={this.goBack()}>
      <StatusBar
        testID="statusBarVideoStimuli"
        backgroundColor="transparent"
        hidden
      />
        <CameraView />
      </View>);
  }
}


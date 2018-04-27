import { AppRegistry } from 'react-native';
import {StackNavigator} from "react-navigation";
import MainScreen from './app/Home';
import VideoScreen from './app/Video';

const SimpleApp = StackNavigator({
  Main: { screen: MainScreen },
  Video: { screen: VideoScreen, title: "Second Screen" }
});

export default SimpleApp;

AppRegistry.registerComponent('SpikeHybrid', () => SimpleApp);

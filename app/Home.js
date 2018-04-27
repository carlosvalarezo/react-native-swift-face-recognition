import React, {Component} from 'react';
import {
    Button,
    Platform,
    Text,
    View
} from 'react-native';

import styles from "../styles/main";
import {navigate} from "react-navigation";

export default class Home extends Component<{}> {
    static navigationOptions = {
        title : 'Welcome',
    };

    constructor(props) {
        super(props);       
    }

    render() {
        const {navigate} = this.props.navigation;

        return (<View style={styles.container}>
                 <Button
                    title="Open camera"
                    onPress={() => navigate('Video', {text: ""})}/>
                </View>);
    }
}


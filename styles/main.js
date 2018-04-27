import {StyleSheet} from "react-native";

const styles = StyleSheet.create({
    container : {
        flex : 1,
        justifyContent : 'center',
        alignItems : 'center',
        backgroundColor : '#F5FCFF',
    },
    welcome : {
        fontSize : 20,
        textAlign : 'center',
        margin : 10,
    },
    instructions : {
        textAlign : 'center',
        color : '#333333',
        marginBottom : 5,
    },
    container2 : {
        flex : 1,
        flexDirection : 'column',
        backgroundColor : 'black'
    },
    redText : {
        color : 'red'
    },
    preview : {
        flex : 1,
        justifyContent : 'flex-end',
        alignItems : 'center'
    },
    capture : {
        flex : 0,
        backgroundColor : '#fff',
        borderRadius : 5,
        padding : 15,
        paddingHorizontal : 20,
        alignSelf : 'center',
        margin : 20
    }
});

export default styles;

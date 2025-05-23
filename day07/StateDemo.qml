import QtQuick

Rectangle{
    id:control;
    width:360;
    height:240;
    color:"#EEEEEE";
    Text{
        id:centerText;
        text:"A Single Text";
        anchors.centerIn: parent;
        font.pixelSize: 24;
        MouseArea{
            id:mouseArea;
            anchors.fill: parent;
            onReleased: {
                centerText.state = "redText";
            }
        }
        states:[
            State{
                name:"redText";
                changes:[
                    PropertyChanges {
                        target: centerText;
                        color:"red";
                    }
                ]
            },
            State{
                name:"blueText";
                when:mouseArea.pressed;
                // changes:[
                    PropertyChanges {
                        target: centerText;
                        color:"blue";
                        font.bold: true;
                        font.pixelSize: 32;
                    }
                // ]
            }
        ]
        state:"redText";
    }
}

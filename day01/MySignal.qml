import QtQuick

Item {

    Rectangle{
        width:320;
        height:240;
        color:"#c0c0c0";
        Text{
            id:coloredText;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 4;
            text:"Hello World!";
            font.pixelSize: 32;
        }

        Component{
            id:colorComponent;
            Rectangle{
                id:colorPicker;
                width:50;
                height:30;
                signal colorPicked(color clr);
                MouseArea{
                    anchors.fill: parent;
                    onPressed:colorPicker.colorPicked(colorPicker.color);
                }
            }
        }

        Loader{
            id:redLoader;
            anchors.left: parent.left;
            anchors.leftMargin: 4;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: 4;
            sourceComponent:colorComponent;
            onLoaded:{
                item.color="red";
            }
        }
        Loader{
            id:blueLoader;
            anchors.left: redLoader.right;
            anchors.leftMargin: 4;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: 4;
            sourceComponent:colorComponent;
            onLoaded:{
                item.color="blue";
            }
        }
        Connections{
            target: redLoader.item;
            function onColorPicked(clr){
                coloredText.color = clr;
            }
        }
        Connections{
            target: blueLoader.item;
            function onColorPicked(clr){
                coloredText.color = clr;
            }
        }

    }

}

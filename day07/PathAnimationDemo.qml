import QtQuick

Canvas{
    width:400;
    height:240;
    onPaint:{
        var ctx = getContext("2d");
        ctx.lineWidth = 4;
        ctx.strokeStyle ="red";
        ctx.beginPath();
        ctx.arc(200,0,160,Math.PI*2,0,false);
        ctx.stroke();
    }
    Rectangle{
        id:rect;
        width:40;
        height:40;
        color:"blue";
        x:20;
        y:0;
        MouseArea{
            anchors.fill:parent;
            id:mouseArea;
            onClicked:pathAnimation.start();
        }
        PathAnimation{
            id:pathAnimation;
            target:rect;
            duration:6000;
            anchorPoint: "20,20";
            orientationEntryDuration: 200;
            orientationExitDuration: 200;
            easing.type: Easing.InOutCubic;
            // orientation: PathAnimation.TopFirst;
            path:Path{
                startX: 40;
                startY:0;
                PathArc{
                    x:360;
                    y:0;
                    useLargeArc: true;
                    radiusX:160;
                    radiusY:160;
                    direction: PathArc.Counterclockwise;
                }
            }
        }
    }
}


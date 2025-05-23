import QtQuick
import QtQuick.Controls

Rectangle{
    id:control;
    width: 360;
    height:420;
    color:"#E0E0E0";
    focus:true;
    Row{
        id:bubbles;
        anchors.top:parent.top;
        anchors.horizontalCenter: parent.horizontalCenter;
        spacing:2;
        property int diedCount:0;
        Component.onCompleted: {
            var i=0;
            var qmlStringBegin = "
            import QtQuick;
            Image{
                width:30;
                height:30;
                property var died:false;
                source: \"qrc:/source/icons/bubble_";
            for(;i<8;++i){
                var qmlString = qmlStringBegin + (i+1) +".png\";}";
                bubbles.children[i] = Qt.createQmlObject(qmlString,bubbles,"DynamicImage");
            }
        }
        function allDie(){
            return diedCount === children.length;
        }
        function reset(){
            diedCount = 0;
            var i =0;
            var bubble;
            for(;i<bubbles.children.length;++i){
                bubble = bubbles.children[i];
                bubble.died = false;
                bubble.source = "qrc:/source/icons/bubble_"+(i+1)+".png";
                bubble.opacity =1.0;
            }
        }
    }
    Text{
        id:scoreInfo;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top:bubbles.bottom;
        anchors.topMargin: 4;
        font.pixelSize: 26;
        font.bold: true;
        color:"blue";
    }
    Image{
        id:turret;//指针
        width:50;
        height: 80;
        anchors.bottom: parent.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        source:"qrc:/source/icons/turret.png";
        transformOrigin: Item.Bottom;
    }
    Image{
        id:bullet;//子弹
        width:40;
        height:40;
        source:"qrc:/source/icons/knife.png";
        x:turret.x;
        y:turret.y;
        z:2;
        visible:false;
    }
    NumberAnimation{
        property int rotateAngle:0;
        function rotate(angle){
            rotateAngle += angle;
            if(running === false){
                rotateTurret();
            }
        }
        function rotateTurret(){
            if(rotateAngle != 0){
                from = turret.rotation;
                to = turret.rotation + rotateAngle;
                if(to > 80) to =80;
                else if(to<-80) to = -80;
                var distance = to -from;
                duration = Math.min(100*Math.abs(distance/3),800);
                start();
                rotateAngle = 0;
            }
        }
        id:animateTurret;
        target:turret;
        property:"rotation";
        onStopped:{
            rotateTurret();
        }
    }
    NumberAnimation{
        id:aboutDie;
        property:"opacity";
        duration:400;
        from:1.0;
        to:0;
        onStopped:{
            showDie.start();
        }
    }
    NumberAnimation{
        id:showDie;
        property:"opacity";
        duration:400;
        from:0;
        to:0.6;
        property var diedImage;
        onStarted: {
            target.source = diedImage;
        }
        onStopped: {
            control.resetBullet();
            bubbles.diedCount++;
            if(bubbles.allDie() === true){
                passed.showPass(true);
                deadline.stop();
                control.showScore();
            }
        }
    }
    ParallelAnimation{
        id:animateBullet;
        property int fire:0;// 0 -- init; 1 -- shotting ;2 -- resetting
        property int diedBubble:-1;
        function caculateDieBubble(){
            var crossX = turret.rotation === 0?
                        (control.width/2 - bullet.width/2):
                        (control.width/2 - bullet.width/2)+(15-(control.height - bullet.height/2))/Math.tan((90+turret.rotation)*0.017453293);
            var i = 0;
            var bubble;
            for(diedBubble = -1 ;i<bubbles.children.length;++i){
                bubble = bubbles.children[i];
                if(crossX > bubbles.x + bubble.x && crossX < bubble.x + bubble.x + bubble.width){
                    if(bubble.died === false){
                        diedBubble = i;
                        break;
                    }
                }
            }
        }
        NumberAnimation{
            id:animateBulletX;
            target: bullet;
            property:"x";
            duration:1200;
            easing.type: Easing.OutCubic;
        }
        NumberAnimation{
            id:animateBulletY;
            target: bullet;
            property:"y";
            duration:1200;
            easing.type:Easing.OutCubic;
        }
        onStopped:{
            if(fire === 1){
                if(diedBubble >= 0){
                    var bubble = bubbles.children[diedBubble];
                    bubble.died = true;
                    showDie.diedImage = "qrc:/source/icons/frozen_"+(diedBubble+1)+".png";
                    aboutDie.target = bubble;
                    showDie.target = bubble;
                    aboutDie.start();
                }else{
                    control.resetBullet();
                }
            }else{
                fire = 0;
                bullet.visible = false;
                if(control.requestReset === true){
                    control.requestReset = false;
                    playGame.enabled = true;
                }
            }
        }
    }
    function fire(){
        if (playGame.enabled || animateBullet.fire != 0) return;

        bullet.visible = true;
        animateBullet.caculateDieBubble();
        if(playGame.enabled || animateBullet.fire != 0) return;
        bullet.visible = true;
        animateBullet.caculateDieBubble();
        animateBulletX.duration = 1200;
        animateBulletX.from = bullet.x;
        if(turret.rotation === 0) animateBulletX.to = bullet.x;
        else animateBulletX.to = (control.width/2 - bullet.width/2) - (control.height - bullet.height/2)/Math.tan((90+turret.rotation)*0.017453293);
        animateBulletY.duration =1200;
        animateBulletY.from = bullet.y;
        animateBulletY.to = 5;
        animateBullet.start();
        animateBullet.fire = 1;
        console.log("Turret rotation:", turret.rotation);
        console.log("Bullet target X:", animateBulletX.to, "Y:", animateBulletY.to);
    }
    function resetBullet(){
        if(animateBullet.fire === 1){
            animateBullet.fire = 2;
            animateBulletX.from = bullet.x;
            animateBulletX.to = control.width/2 - bullet.width/2;
            animateBulletX.duration = 500;
            animateBulletY.from = bullet.y;
            animateBulletY.to = control.height - bullet.height/2;
            animateBulletY.duration =500;
            animateBullet.start();
        }
    }
    Text{
        id:leftSeconds;
        anchors.centerIn:parent;
        color:"red";
        font.pixelSize: 20;
    }
    Timer{
        id:deadline;
        interval: 1000;
        repeat:true;
        onTriggered:{
            var curDate = new Date();
            var milliSeconds = maxGameTime -(curDate.getTime() - startDate.getTime());
            if(milliSeconds <= 0){
                failed.showFailed(true);
                deadline.stop();
            }else{
                var seconds = Math.round(milliSeconds/1000);
                if(seconds === 0){
                    seconds =1;
                }
                leftSeconds.text = "Left Time:"+seconds;
            }
        }
    }
    function showScore(){
        var curDate = new Date();
        var seconds = Math.round((curDate.getTime() - startDate.getTime())/1000);
        if(seconds <= 27){
            scoreInfo.text = +seconds+"S! Excellent!";
        }else if( seconds <=32){
            scoreInfo.text = +seconds+"S! Good!";
        }else if(seconds <=42){
            scoreInfo.text = +seconds+"S! Yes,pass!";
        }else{
            scoreInfo.text = +seconds+"S! Try again!";
        }
    }
    property var startDate;
    property bool requestReset: false;
    readonly property int maxGameTime: 70000;
    Button{
        id:resetGame;
        text:"Reset";
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        onClicked:{
            control.requestReset = true;
            bubbles.reset();
            deadline.stop();
            turret.rotation = 0;
            if(animateBullet.fire == 1){
                control.resetBullet();
            }else if(animateBullet.fire == 0){
                playGame.enabled = true;
                control.requestReset = false;
            }
            failed.showFailed(false);
            passed.showPass(false);
            leftSeconds.text = "";
            scoreInfo.text = "";
        }
    }
    Button{
        id:playGame;
        text:"Play";
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: resetGame.top;
        anchors.bottomMargin: 4;
        onClicked:{
            control.startDate = new Date();
            deadline.restart();
            playGame.enabled = false;
            control.requestReset = false;
            control.resetBulletPos();
            control.focus = true;
        }
    }
    Image{
        id:passed;
        visible:false;
        width:200;
        height:51;
        x:control.width /2 -100;
        source:"qrc:/source/icons/passed.png";
        z:3;

        SpringAnimation{
            id:springY;
            target: passed;
            property:"y";
            spring:3;
            damping:0.1;
            epsilon:0.25;
        }
        function showPass(bShow){
            visible = bShow;
            if(bShow === true){
                springY.from = y;
                springY.to = control.height/2 - height/2;
                springY.start();
            }else{
                y =0;
            }
        }
    }

    Image {
        id: failed
        visible:false;
        width:180;
        height:37;
        source: "qrc:/source/icons/failed.png"
        z:3;
        states:[
            State{
                name:"show";
                AnchorChanges{
                    target: failed;
                    anchors.horizontalCenter: control.horizontalCenter;
                    anchors.verticalCenter: control.verticalCenter;
                }
            },
            State{
                name:"hide";
                AnchorChanges{
                    target: failed;
                    anchors.left: control.left;
                    anchors.top: control.top;
                }
            }
        ]
        state:"hide";
        transitions: Transition {
            AnchorAnimation{
                duration: 1000;
                easing.type: Easing.OutInCubic;
            }
        }
        function showFailed(bShow){
            visible = bShow;
            state = bShow?"show":"hide";
        }
    }
    Keys.enabled: true;
    Keys.onReturnPressed: fire();
    Keys.onSpacePressed: {
        console.log("fire");
        fire();
    }
    Keys.onLeftPressed: {
        console.log("Left pressed, current rotation:", turret.rotation);
        animateTurret.rotate(-3);
    }
    Keys.onRightPressed: {
        console.log("Right pressed, current rotation:", turret.rotation);
        animateTurret.rotate(3);
    }
    function resetBulletPos(){
        bullet.x = control.width/2 - bullet.width/2;
        bullet.y = control.height/ - bullet.height/2;
    }

    onHeightChanged: {
        bullet.x = control.width/2 - bullet.width/2;
    }
    onWidthChanged: {
        bullet.y = control.height - bullet.height/2;
    }

}


import QtQuick

Flickable{
    width:200;
    height: 200;
    contentWidth: image.width;
    contentHeight: image.height;
    Image{
        id:image;
        source:"qrc:/source/icons/avatar7.jpg";
    }
}

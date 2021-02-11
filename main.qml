import QtQuick 2.7
import QtQuick.Window 2.2
import QtLocation 5.9
import QtQuick.Controls 2.2
import Qt3D.Input 2.0
import QtPositioning 5.8

//Главное окно отображения всех объектов QML
Window
{
    id: myWin
    objectName: "window"
    visible: true
    width: 512
    height: 512
    minimumHeight: 512
    minimumWidth: 512

    //Подключение объекта карты
    ItemMap
    {
        id: map
    }

    //Подключение объекта гео-стрелки
    ItemArrowLocation
    {
           id:mainArrowLocation

           anchors.right: parent.right
           anchors.rightMargin: 22
           anchors.top: parent.top
           anchors.topMargin: 240
           width: 50
           height: 50
    }

    //Кнопка вызова фильтра отображения
    Rectangle
    {
      id:itemFilter
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.rightMargin: 30
      anchors.topMargin: 315
      width: 48
      height: 48
      color: "#00000000"

      MouseArea
      {
        anchors.fill: parent
        onClicked:
        {
           mainFilterRect.state = mainFilterRect.state === "menu" ? "back" : "menu"
        }
      }

      //Иконка фильтра
      Item {
        id: root
        width: 24
        height: 24
        anchors.centerIn: parent

        Image
        {
            source: "img/icon_filter.png"
        }
      }
    }

    //Подключение объекта фильтра отображения
    ItemFilterMain
    {
       id: mainFilterRect
    }

    //Подключение объекта изменения области видимости карты
    MenuLookChange
    {
        id:menuLook
        x:0
        y:0
    }

}

import QtQuick 2.9
import QtQuick.Window 2.2

//Объект фильтра для настройки отображения (друг, враг)
Item {
  id: root

  signal clickBtnFilter(string nameBtn)

  width: myWin.width - 18
  height: 190

  Rectangle
  {
     id: mainFilterRect
     x: 8
     y: 2000
     color: "#cc7099f3"
     width: parent.width
     height: 200
     antialiasing: true
     radius: 5
     visible: false
   }  

  Rectangle
  {
     id: buttonTop_1
     x: 40
     y: 2000
     color: "white"
     width: 100
     height: 100
     antialiasing: true
     radius: 5
     visible: false
     border.width: 3

     Text {
         id: textCircle
         text: qsTr("Враг")
         font.pointSize: 10
         anchors.centerIn: parent
     }

     MouseArea
     {
         anchors.fill: parent
         onClicked:
         {
             if(buttonTop_1.border.color == "#000000")
             {
                buttonTop_1.border.color = "#DC143C"
             }
             else
             {
                buttonTop_1.border.color = "#000000"
             }

             root.clickBtnFilter(textCircle.text)
         }
     }
   }

  Rectangle
  {
     id: buttonTop_2
     y: 2000
     anchors.centerIn: mainFilterRect
     color: "white"
     width: 100
     height: 100
     antialiasing: true
     radius: 5
     visible: false
     border.width: 3

     Text {
         id: textPolygon
         text: qsTr("Друг")
         font.pointSize: 10
         anchors.centerIn: parent
     }

     MouseArea
     {
         anchors.fill: parent
         onClicked:
         {
             if(buttonTop_2.border.color == "#000000")
                buttonTop_2.border.color = "#DC143C"
             else
                buttonTop_2.border.color = "#000000"

             root.clickBtnFilter(textPolygon.text)
         }
     }
   }

  Rectangle
  {
     id: buttonTop_3
     y: 2000
     anchors.right: parent.right
     anchors.rightMargin: 40
     color: "white"
     width: 100
     height: 100
     antialiasing: true
     radius: 5
     visible: false
   }

  Rectangle
  {
     id: buttonClose
     y: 2000
     anchors.top: mainFilterRect.top
     anchors.topMargin: 8
     anchors.right: mainFilterRect.right
     anchors.rightMargin: 8
     color: "#ea6969"
     width: 20
     height: 20
     antialiasing: true
     radius: 5
     visible: false

     MouseArea
     {
         anchors.fill: parent
         onClicked:
         {
            root.state = root.state === "menu" ? "back" : "menu"
         }
     }
   }

  Rectangle
  {
     id: topTab
     x: myWin.width * 0.5
     y: 2000
     color: "#62a8bb"
     width: 170
     height: 25
     antialiasing: true
     radius: 50
     visible: false

    Rectangle
    {
       id: activeLine_Top
       anchors.top: parent.top
       anchors.topMargin: 5
       anchors.left: parent.left
       anchors.leftMargin: 25
       color: "white"
       width: 120
       height: 3
       antialiasing: true
       radius: 5
    }

    Rectangle
    {
       id: activeLine_Bottom
       anchors.top: parent.top
       anchors.topMargin: 15
       anchors.left: parent.left
       anchors.leftMargin: 55
       color: "white"
       width: 60
       height: 3
       antialiasing: true
       radius: 5
    }

    MouseArea
    {
        property bool flag: false
        property var preY: root.y

        id: mouseAreaTab
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onPressed:
        {
           flag = true

           preY = root.y
        }
        onReleased:
        {
            flag = false

            if(root.y >= (preY+120))
            {
                root.y = preY
                root.state = root.state === "menu" ? "back" : "menu"
            }
            else
            {
               root.y = preY
            }
        }
        onMouseYChanged:
        {
            if(flag == true)
            {
                root.y += mouseY * 0.5
            }
        }
    }
   }

  //Описание анимаций элементов
  property int animationDuration: 600
  property int animationDurationVisible: 300

  state: "menu"
  states: [
    State {
      name: "menu"
    },

    State {
      name: "back"

      PropertyChanges
      {
          target: mainFilterRect; visible: true;
      }

      PropertyChanges
      {
          target: buttonTop_1; visible: true;
      }

      PropertyChanges
      {
          target: buttonTop_2; visible: true;
      }

      PropertyChanges
      {
          target: buttonTop_3; visible: true;
      }

      PropertyChanges
      {
          target: buttonClose; visible: true;
      }

      PropertyChanges
      {
          target: topTab; visible: true;
      }


      PropertyChanges
      {
          target: mainFilterRect;  x: 8; y:  myWin.height - mainFilterRect.height - 8
      }

      PropertyChanges
      {
          target: buttonTop_1;  x: 40; y: myWin.height - mainFilterRect.height + 38
      }

      PropertyChanges
      {
          target: buttonTop_2;  x: 130; y: myWin.height - mainFilterRect.height + 38
      }

      PropertyChanges
      {
          target: buttonTop_3;  x: 130; y: myWin.height - mainFilterRect.height + 38
      }

      PropertyChanges
      {
          target: buttonClose;  x: 130; y: myWin.height - mainFilterRect.height + 3
      }

      PropertyChanges
      {
          target: topTab;  x: mainFilterRect.width * 0.5 - topTab.width * 0.5 ; y: myWin.height - mainFilterRect.height - topTab.height * 0.5
      }
    }
  ]

  transitions: [
    Transition {
      PropertyAnimation { target: mainFilterRect; properties: " visible"; duration: animationDurationVisible; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: buttonTop_1; properties: " visible"; duration: animationDurationVisible; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: buttonTop_2; properties: " visible"; duration: animationDurationVisible; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: buttonTop_3; properties: " visible"; duration: animationDurationVisible; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: buttonClose; properties: " visible"; duration: animationDurationVisible; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: topTab; properties: " visible"; duration: animationDurationVisible; easing.type: Easing.InOutQuad }


      PropertyAnimation { target: mainFilterRect; properties: "x, y"; duration: animationDuration; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: buttonTop_1; properties: "x, y "; duration: animationDuration; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: buttonTop_2; properties: "x, y "; duration: animationDuration; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: buttonTop_3; properties: "x, y "; duration: animationDuration; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: buttonClose; properties: "x, y "; duration: animationDuration; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: topTab; properties: "x, y "; duration: animationDuration; easing.type: Easing.InOutQuad }

      }
  ]

}

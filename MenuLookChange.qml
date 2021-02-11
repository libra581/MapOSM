import QtQuick 2.9
import QtQuick.Controls 2.2

//Панель настройки видимости и отображения карты
//Поворот карты, вертикальная панорама, поле обзора
Item {
  id: rootMenuChangeLook

  width: myWin.width / 3
  height: myWin.height

  property int widthLookMenu: (myWin.width / 3)
  property int widthLookSlider: (mainLookRect.width * 0.25)

  Rectangle
  {
     id: mainLookTabRect
     x: ( mainLookRect.x + mainLookRect.width ) - mainLookTabRect.width * 0.5
     y: myWin.height * 0.5 - 50
     color: "#7099f3"
     width: 50
     height: 100
     antialiasing: true
     radius: 5

     MouseArea
     {
         anchors.fill: parent
         onClicked:
         {
            rootMenuChangeLook.state = rootMenuChangeLook.state === "menu" ? "back" : "menu"
         }         
     }

     focus: true

     property bool flagCtrl: false
     property bool flagKey1: false

     Keys.onPressed:
     {
         if (event.key === Qt.Key_Control )
         {
             flagCtrl = true
         }

         if(flagCtrl && event.key === Qt.Key_1)
         {
            rootMenuChangeLook.state = rootMenuChangeLook.state === "menu" ? "back" : "menu"
         }

         event.accepted = true;
     }

     Keys.onReleased:
     {
         if (event.key === Qt.Key_Control)
         {
             flagCtrl = false
         }

         event.accepted = true;
     }

     Rectangle
     {
         id: arrowTopLeft
         x: 20
         y: 30
         color: "#ffffff"
         width: 35
         height: 4
         antialiasing: true
         radius: 5
         rotation: 70
     }

     Rectangle
     {
         id: arrowButtonLeft
         x: 20
         y: 60
         color: "#ffffff"
         width: 35
         height: 4
         antialiasing: true
         radius: 5
         rotation: -70
     }
   }

  Rectangle
  {
     id: mainLookRect
     x: -widthLookMenu
     y: 0
     color: "#7099f3"
     width: parent.width
     height: parent.height
     antialiasing: true
  }

  //Объявление объектов Text
  ItemTextGradient
  {
      x: sliderMapBearing.x - 15
      y:0
      setText: "Поворот"
  }

  ItemTextGradient
  {
      x: sliderMapTilt.x - 15
      y:0
      setText: "Вертикальная панорама"
  }

  ItemTextGradient
  {
      x: sliderMapFov.x - 15
      y:0
      setText: "Поле обзора"
  }

  //Объявление объектов Slider для объектов Text
  property string colorSliderBack: "#3ee08d"

  //Слайдер поворота
  Slider
  {
      id:sliderMapBearing
      x: mainLookRect.x + 20
      y: 35
      height: myWin.height - 45
      value: map.bearing
      from: 0
      to: 360
      orientation: Qt.Vertical
      onValueChanged:
      {
         map.bearing = value;
      }

      background: Rectangle {
          y: sliderMapBearing.topPadding + sliderMapBearing.availableHeight / 2 - height / 2
          x: sliderMapBearing.leftPadding + 11
          implicitWidth: 4
          implicitHeight: parent.height
          width:  6
          height: implicitHeight
          radius: 2
          color: colorSliderBack

          Rectangle {
              width:  parent.width
              height: sliderMapBearing.visualPosition * parent.height
              color: "#dadadb"
              radius: 2
          }
      }

     handle: Rectangle {
         id: circleSlider
         y: sliderMapBearing.visualPosition * (parent.height - height)//(control.availableHeight - height)
         x: sliderMapBearing.leftPadding + sliderMapBearing.availableWidth / 2 - width/ 2
         implicitWidth: 26
         implicitHeight: 26
         radius: 13
         color: sliderMapBearing.pressed ? "#f0f0f0" : "#f6f6f6"
         border.color: "#bdbebf"
     }
  }

  //Слайдер вертикальной панорамы
  Slider
  {
      id:sliderMapTilt
      x: sliderMapBearing.x + widthLookSlider
      y: 35
      height: myWin.height - 45
      value: map.tilt
      from: map.minimumTilt
      to: map.maximumTilt
      orientation: Qt.Vertical
      onValueChanged:
      {
         map.tilt = value;
      }

      background: Rectangle {
          y: sliderMapTilt.topPadding + sliderMapTilt.availableHeight / 2 - height / 2
          x: sliderMapTilt.leftPadding + 11
          implicitWidth: 4
          implicitHeight: parent.height
          width:  6
          height: implicitHeight
          radius: 2
          color: colorSliderBack

          Rectangle {
              width:  parent.width
              height: sliderMapTilt.visualPosition * parent.height
              color: "#dadadb"
              radius: 2
          }
      }

     handle: Rectangle {
         id: circleSlider_2
         y: sliderMapTilt.visualPosition * (parent.height - height)//(control.availableHeight - height)
         x: sliderMapTilt.leftPadding + sliderMapTilt.availableWidth / 2 - width/ 2
         implicitWidth: 26
         implicitHeight: 26
         radius: 13
         color: sliderMapTilt.pressed ? "#f0f0f0" : "#f6f6f6"
         border.color: "#bdbebf"
     }
  }

  //Слайдер поля обзора
  Slider
  {
      id:sliderMapFov
      x: sliderMapTilt.x + widthLookSlider
      y: 35
      height: myWin.height - 45
      value: map.fieldOfView
      from: map.minimumFieldOfView
      to: map.maximumFieldOfView
      orientation: Qt.Vertical
      onValueChanged:
      {
         map.fieldOfView = value;
      }

      background: Rectangle {
          y: sliderMapFov.topPadding + sliderMapFov.availableHeight / 2 - height / 2
          x: sliderMapFov.leftPadding + 11
          implicitWidth: 4
          implicitHeight: parent.height
          width:  6
          height: implicitHeight
          radius: 2
          color: colorSliderBack

          Rectangle {
              width:  parent.width
              height: sliderMapFov.visualPosition * parent.height
              color: "#dadadb"
              radius: 2
          }
      }

     handle: Rectangle {
         id: circleSlider_3
         y: sliderMapFov.visualPosition * (parent.height - height)
         x: sliderMapFov.leftPadding + sliderMapFov.availableWidth / 2 - width/ 2
         implicitWidth: 26
         implicitHeight: 26
         radius: 13
         color: sliderMapFov.pressed ? "#f0f0f0" : "#f6f6f6"
         border.color: "#bdbebf"         
     }
  }

  //Настройка анимации
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
          target: mainLookRect;  x: 0
      }

      PropertyChanges
      {
          target: arrowTopLeft;  x: 20; rotation: 113.02
      }

      PropertyChanges
      {
          target: arrowButtonLeft;  x: 20; rotation: -113.02
      }

      }
  ]

  transitions: [
    Transition {
          PropertyAnimation { target: mainLookRect; properties: "x"; duration: animationDuration; easing.type: Easing.InOutQuad }
          PropertyAnimation { target: arrowTopLeft; properties: "x,rotation"; duration: animationDuration; easing.type: Easing.InOutQuad }
          PropertyAnimation { target: arrowButtonLeft; properties: "x,rotation"; duration: animationDuration; easing.type: Easing.InOutQuad}
      }
  ]
}

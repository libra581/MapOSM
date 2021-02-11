import QtQuick 2.0
import QtPositioning 5.8

//Объект навигационной стрелки.
//Позволяет найти корабль,
//а также по двойному щелчку - следовать камере за кораблем
Item {
  id: root
  width: 24
  height: 24

  property bool clickTrackOn: true

  Connections
  {
     target: map.gesture

     onFlickStarted:
     {
        clickTrackOn = false
     }

     onFlickFinished:
     {
        clickTrackOn = true
     }
  }

  Image
  {
      id:imgArrow
      source: "img/arrow.png"
  }

  MouseArea
  {
    anchors.fill: parent
    onClicked:
    {

       if ( clickTrackOn )
       {
          map.center = map.mapItemMy.coordinate
       }
    }

    onDoubleClicked:
    {
        if ( clickTrackOn )
        {
            map.flagTrackPositionOn = !map.flagTrackPositionOn

            if (root.rotation === 0)
            {
                root.rotation = 30
                map.gesture.enabled = false
            }
            else
            {
                root.rotation = 0
                map.gesture.enabled = true
            }
        }
    }
  }
}

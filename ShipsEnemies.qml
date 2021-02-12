import QtQuick 2.9
import QtQuick.Window 2.2
import QtLocation 5.9
import QtQuick.Controls 2.2
import Qt3D.Input 2.0
import QtPositioning 5.8

//Группа элементов из 2 кораблей Enemy для карты
MapItemGroup
{
    property double latitudeForEnemyShip:  Math.random() * 0.10 - 0.02
    property double longitudeForEnemyShip: Math.random() * 0.10 - 0.02

    //Радиус видимости
    MapCircle
    {
        center: quickItem.coordinate
        radius: 30000.0
        color: '#ff0033'
        border.width: 1
        opacity: 0.5
    }

    //Направление корабля из расчета координат предыдущих двух точек
    MapPolyline
    {
         line.width: 3
         line.color: 'red'
         path: [
             { latitude:  quickItem.coordinate.latitude,
               longitude: quickItem.coordinate.longitude },

             { latitude: quickItem.coordinate.latitude + latitudeForEnemyShip * 5,
               longitude:quickItem.coordinate.longitude + longitudeForEnemyShip * 5}
         ]
    }

   //Отображение иконки корабля
   MapQuickItem
   {
       id:quickItem
       anchorPoint.x: img_enemShip.width * 0.5
       anchorPoint.y: img_enemShip.height * 0.5

       coordinate: QtPositioning.coordinate(59.91,10.75)

       sourceItem: Image
                   {
                       id: img_enemShip
                       source: "qrc:/img/pirates_ship.png"
                       smooth: true
                       sourceSize.width: 64
                       sourceSize.height: 64
                   }

       //Таймер каждую секунду выдает новую позицию корабля случайным образом
       Timer
       {
           interval: 1000
           running: true
           repeat: true
           onTriggered:
           {
               latitudeForEnemyShip  = Math.random() * 0.10 - 0.02
               longitudeForEnemyShip = Math.random() * 0.10 - 0.02
               quickItem.coordinate.latitude  += latitudeForEnemyShip
               quickItem.coordinate.longitude += longitudeForEnemyShip
           }
       }
   }

   property double latitudeForEnemyShip2:  Math.random() * 0.10 - 0.08
   property double longitudeForEnemyShip2: Math.random() * 0.10 - 0.08

   MapCircle
   {
       center: quickItem_2.coordinate
       radius: 30000.0
       color: '#ff0033'
       border.width: 1
       opacity: 0.5
   }

   //Направление корабля из расчета координат предыдущих двух точек
   MapPolyline
   {
        line.width: 3
        line.color: 'red'
        path: [
            { latitude:  quickItem_2.coordinate.latitude,
              longitude: quickItem_2.coordinate.longitude },

            { latitude: quickItem_2.coordinate.latitude + latitudeForEnemyShip2 * 5,
              longitude:quickItem_2.coordinate.longitude + longitudeForEnemyShip2 * 5}
        ]
   }

   MapQuickItem
   {
       id:quickItem_2
       anchorPoint.x: img_enemShip.width * 0.5
       anchorPoint.y: img_enemShip.height * 0.5

       coordinate: QtPositioning.coordinate(62.00,10.75)

       sourceItem: Image
                   {
                       id: img_enemShip_2
                       source: "qrc:/img/pirates_ship.png"
                       smooth: true
                       sourceSize.width: 64
                       sourceSize.height: 64
                   }

       Timer
       {
           interval: 1000
           running: true
           repeat: true
           onTriggered:
           {
               latitudeForEnemyShip2  = Math.random() * 0.10 - 0.02
               longitudeForEnemyShip2 = Math.random() * 0.10 - 0.02
               quickItem_2.coordinate.latitude  += latitudeForEnemyShip2
               quickItem_2.coordinate.longitude += longitudeForEnemyShip2
           }
       }
   }
}

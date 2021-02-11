import QtQuick 2.7
import QtQuick.Window 2.2
import QtLocation 5.9
import QtQuick.Controls 2.2
import Qt3D.Input 2.0
import QtPositioning 5.8

//Объект загрузки и отображения карты
//в виде тайлов OSM map
Map
{
    id: map
    anchors.fill: parent
    activeMapType: map.supportedMapTypes[2]
    maximumZoomLevel: 7
    minimumZoomLevel: 2

    property alias mapItemMy: itemShip
    property bool flagTrackPositionOn: false
    property bool followme: false

    //Уровни масштаба
    property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]

    //Функция подсчитывания масштаба карты взависимости от уровня масштаба
    function calculateScale()
    {
        var coord1, coord2, dist, text, f
        f = 0
        coord1 = map.toCoordinate(Qt.point(0,scale.y))
        coord2 = map.toCoordinate(Qt.point(0+scaleImage.sourceSize.width,scale.y))
        dist = Math.round(coord1.distanceTo(coord2))

        if (dist === 0) {
            // not visible
        } else {
            for (var i = 0; i < scaleLengths.length-1; i++) {
                if (dist < (scaleLengths[i] + scaleLengths[i+1]) / 2 ) {
                    f = scaleLengths[i] / dist
                    dist = scaleLengths[i]
                    break;
                }
            }
            if (f === 0) {
                f = dist / scaleLengths[i]
                dist = scaleLengths[i]
            }
        }

        text = this.formatDistance(dist)
        scaleImage.width = (scaleImage.sourceSize.width * f) - 2 * scaleImageLeft.sourceSize.width
        scaleText.text = text
    }

    //Функция для указания меры длинны масштаба
    function formatDistance(distance)
    {
        if (distance < 1000)
            return distance.toFixed(0) + " m";

        var km = distance/1000;
        if (km < 10)
            return km.toFixed(1) + " km";

        return km.toFixed(0) + " km";
    }

    Component.onCompleted:
    {
        map.center = QtPositioning.coordinate(59.91, 10.75)
    }

    Connections
    {
       target: mainFilterRect
       onClickBtnFilter:
       {
           switch(nameBtn)
           {
               case 'Друг':
                        groupMyShip.visible = !groupMyShip.visible
                        break;
               case 'Враг':
                        enemShip.visible = !enemShip.visible
                        break;
           }
       }
    }

    gesture.flickDeceleration: 2000
    gesture.enabled: true

    onCenterChanged:{
        scaleTimer.restart()
        if (map.followme)
            if (map.center !== positionSource.position.coordinate)
                map.followme = false
    }

    onZoomLevelChanged:{
        scaleTimer.restart()
        if (map.followme)
            map.center = positionSource.position.coordinate
    }

    onWidthChanged:{
        scaleTimer.restart()
    }

    onHeightChanged:{
        scaleTimer.restart()
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Plus)
        {
            map.zoomLevel++
        }
        else if (event.key === Qt.Key_Minus)
        {
            map.zoomLevel--
        }
    }

    Timer {
        id: scaleTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            map.calculateScale()
        }
    }

    //Объект отображения масштаба
    Item {
        id: scale
        visible: scaleText.text != "0 m"
        z: map.z + 3
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        height: scaleText.height * 2
        width: scaleImage.width

        //Первый отрезок масштаба
        Image {
            id: scaleImageLeft
            source: "qrc:/img/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImage.left
        }
        Image {
            id: scaleImage
            source: "qrc:/img/scale.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageRight.left
        }
        Image {
            id: scaleImageRight
            source: "qrc:/img/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }


        Label {
            id: scaleText
            color: "#004EAE"
            anchors.centerIn: parent
            text: "0 m"
        }

        //Второй отрезок масштаба
        Image {
            id: scaleImageLeftAdd
            source: "qrc:/img/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageAdd.left
        }
        Image {
            id: scaleImageAdd
            source: "qrc:/img/scale.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageLeft.right
            width: scaleImage.width
        }

        //Третий отрезок масштаба
        Image {
            id: scaleImageLeftAdd_1
            source: "qrc:/img/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageAdd_1.left
        }
        Image {
            id: scaleImageAdd_1
            source: "qrc:/img/scale.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageLeftAdd.right
            width: scaleImage.width
        }

        //Четвертый отрезок масштаба
        Image {
            id: scaleImageLeftAdd_2
            source: "qrc:/img/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageAdd_2.left
        }
        Image {
            id: scaleImageAdd_2
            source: "qrc:/img/scale.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageLeftAdd_1.right
            width: scaleImage.width
        }

        //Пятый отрезок масштаба
        Image {
            id: scaleImageLeftAdd_3
            source: "qrc:/img/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageAdd_3.left
        }
        Image {
            id: scaleImageAdd_3
            source: "qrc:/img/scale.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageLeftAdd_2.right
            width: scaleImage.width
        }

        Component.onCompleted: {
            map.calculateScale();
        }
    }

    property double latitudeForMyShip: 0.05
    property double longitudeForMyShip: 0.05
    property double multiplierVector: 5

    //Подключение врагов
    ShipsEnemies
    {
        id:enemShip
    }

    //Создание группы элементов отображения на карте
    MapItemGroup
    {
        id:groupMyShip

        //Отображение области видимости на воде корабля
        MapCircle
        {
            center: itemShip.coordinate
            radius: 30000.0
            color: '#006633'
            border.width: 1
            opacity: 0.5
        }

        //Отображение направления корабля
        //из расчета координат предыдущих двух точек
        MapPolyline
        {
             line.width: 3
             line.color: 'green'
             path: [
                 { latitude:  itemShip.coordinate.latitude,
                   longitude: itemShip.coordinate.longitude },

                 { latitude:  itemShip.coordinate.latitude + latitudeForMyShip   + multiplierVector  ,
                   longitude: itemShip.coordinate.longitude + longitudeForMyShip + multiplierVector }
             ]
        }

        MapQuickItem
        {
            id: itemShip
            anchorPoint.x: img_myShip.width * 0.5
            anchorPoint.y: img_myShip.height * 0.5

            coordinate:  QtPositioning.coordinate(60.91 , 10.755)

            onCoordinateChanged:
            {
                if ( flagTrackPositionOn )
                {
                    map.center = itemShip.coordinate
                }
            }

            sourceItem: Item
            {
                Image {
                            id: img_myShip
                            source: "qrc:/img/containership.png"
                            smooth: true
                            sourceSize.width: 64
                            sourceSize.height: 64
                        }
            }

            //Таймер изменения каждую секунду положения корабля
            Timer
            {
                interval: 1000
                running: true
                repeat: true
                onTriggered:
                {
                    itemShip.coordinate.latitude  += latitudeForMyShip
                    itemShip.coordinate.longitude += longitudeForMyShip
                }
            }
        }
    }

    //Подключение плагина OSM online и offline mode
    plugin: Plugin
    {
        name: 'osm';
        PluginParameter
        {
            name: 'osm.mapping.offline.directory'
            value: 'C:/Users/sds/Documents/yamapng/OsmOffline/offline_tiles'
        }
    }

    MouseArea
    {
        anchors.fill: parent

        onWheel:
        {
            //Настройка группы интерфейсных объектов
            //в зависимости от уровня зума
            if (map.zoomLevel === 1)
            {
                btn_minus.enabled = false
                effect_minus.visible = true

                btn_plus.enabled = true
                effect_plus.visible = false

                if (wheel.angleDelta.y === 120)
                {
                    map.zoomLevel += 0.1
                    map.zoomLevel = map.zoomLevel.toFixed(1)
                    btn_minus.enabled = true
                    effect_minus.visible = false
                }
            }
            else if (map.zoomLevel === 7)
            {
                btn_minus.enabled = true
                effect_minus.visible = false

                btn_plus.enabled = false
                effect_plus.visible = true

                if (wheel.angleDelta.y === -120)
                {
                    map.zoomLevel -= 0.1
                    map.zoomLevel = map.zoomLevel.toFixed(1)
                    btn_plus.enabled = true
                    effect_plus.visible = false
                }
            }
            else
            {
                if (wheel.angleDelta.y === 120)
                {
                    map.zoomLevel += 0.1
                    map.zoomLevel = map.zoomLevel.toFixed(1)
                    btn_minus.enabled = true
                    effect_minus.visible = false

                    btn_plus.enabled = true
                    effect_plus.visible = false
                }
                else if (wheel.angleDelta.y === -120)
                {
                    map.zoomLevel -= 0.1
                    map.zoomLevel = map.zoomLevel.toFixed(1)
                    btn_minus.enabled = true
                    effect_minus.visible = false

                    btn_plus.enabled = true
                    effect_plus.visible = false
                }
            }
        }
    }

    Item
    {
        anchors.fill: parent
        id: groupInterfaceItems

        Rectangle
        {
            Image
            {
                id: img_plus
                anchors.fill: parent
                source: 'qrc:/img/navigate_plus.png'

                ShaderEffect {
                              visible: false
                              id: effect_plus
                              width: 40; height: 40
                              property variant src: img_plus
                              vertexShader: "
                                  uniform highp mat4 qt_Matrix;
                                  attribute highp vec4 qt_Vertex;
                                  attribute highp vec2 qt_MultiTexCoord0;
                                  varying highp vec2 coord;
                                  void main() {
                                      coord = qt_MultiTexCoord0;
                                      gl_Position = qt_Matrix * qt_Vertex;
                                  }"
                              fragmentShader: "
                                  varying highp vec2 coord;
                                  uniform sampler2D src;
                                  uniform lowp float qt_Opacity;
                                  void main() {
                                      lowp vec4 tex = texture2D(src, coord);
                                      gl_FragColor = vec4(vec3(dot(tex.rgb,
                                                          vec3(0.344, 0.5, 0.156))),
                                                               tex.a) * qt_Opacity;
                                  }"
                          }

            }

            anchors.rightMargin: 20
            anchors.right: parent.right
            anchors.topMargin: 120
            anchors.top: parent.top
            id: btn_plus
            height: 40

            width: 40

            color: "#00ffffff"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if (map.zoomLevel <= 7)
                    {
                        map.zoomLevel += 0.1
                        effect_plus.visible = false
                        parent.enabled = true

                        effect_minus.visible = false
                        btn_minus.enabled = true

                    }
                    else
                    {
                        effect_plus.visible = true
                        parent.enabled = false
                    }
                }
            }
        }

        Rectangle
        {
            Image
            {
                id: img_minus
                anchors.fill: parent
                source: 'qrc:/img/navigate_minus.png'
                ShaderEffect {
                              id: effect_minus
                              width: 40; height: 40
                              property variant src: img_minus
                              vertexShader: "
                                  uniform highp mat4 qt_Matrix;
                                  attribute highp vec4 qt_Vertex;
                                  attribute highp vec2 qt_MultiTexCoord0;
                                  varying highp vec2 coord;
                                  void main() {
                                      coord = qt_MultiTexCoord0;
                                      gl_Position = qt_Matrix * qt_Vertex;
                                  }"
                              fragmentShader: "
                                  varying highp vec2 coord;
                                  uniform sampler2D src;
                                  uniform lowp float qt_Opacity;
                                  void main() {
                                      lowp vec4 tex = texture2D(src, coord);
                                      gl_FragColor = vec4(vec3(dot(tex.rgb,
                                                          vec3(0.344, 0.5, 0.156))),
                                                               tex.a) * qt_Opacity;
                                  }"

                          }
            }

            anchors.rightMargin: 20
            anchors.right: parent.right
            anchors.topMargin: 180
            anchors.top: parent.top

            id: btn_minus
            enabled: false
            height: 40
            color: "#00ffffff"
            width: 40

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if (map.zoomLevel > 1)
                    {
                        map.zoomLevel -= 0.1
                        effect_minus.visible = false
                        parent.enabled = true

                        effect_plus.visible = false
                        btn_plus.enabled = true
                    }
                    else
                    {
                        effect_minus.visible = true
                        parent.enabled = false
                    }
                }
            }
        }
    }
}

import QtQuick 2.0

//Объект изменения формата отображения текста
Item
{
    property string setText: "Text"

    id:root
    width: 25
    height: parent.height

    Rectangle
    {
        id: gradientRect;
        width: 25
        height: parent.height
        gradient:Gradient
                 {
                     GradientStop { position: 0; color: "white"  }
                     GradientStop { position: 1; color: "yellow" }
                 }
        visible: false;
        layer.enabled: true;
        layer.smooth: true

    }

    Text
    {
        id: labelBearing
        text: setText
        font.pixelSize: 25
        rotation: -90
        anchors.centerIn: gradientRect
        style: Text.Raised
        styleColor: "black"

        layer.enabled: true
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect
                      {
                      property var colorSource: gradientRect;
                      fragmentShader: "
                              uniform lowp sampler2D colorSource;
                              uniform lowp sampler2D maskSource;
                              uniform lowp float qt_Opacity;
                              varying highp vec2 qt_TexCoord0;
                              void main() {
                                  gl_FragColor =
                                      texture2D(colorSource, qt_TexCoord0)
                                      * texture2D(maskSource, qt_TexCoord0).a
                                      * qt_Opacity;
                              }
                          "
                      }
    }
}

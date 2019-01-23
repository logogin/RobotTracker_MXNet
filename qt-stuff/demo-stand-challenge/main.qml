import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.VirtualKeyboard.Settings 2.2
import io.qt.Backend 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 1100
    minimumWidth: 700
    height: 700
    minimumHeight: 500
    title: qsTr("Challenge")

    property int primaryFontSize: 24
    property int secondaryFontSize: 18
    property string backgroundColor: "#ECECEC"
    property bool cameraUpsideDown: false // if you need to rotate viewfinder to 180

    property double timerRate: 0.1 * 1000 // ms, the rate of grabbing frames (one per specified value)
    property string mxNetEndpoint: "http://localhost:8080/predictions/pose"

    Backend {
        id: backend

        onRequestDone: {
            loader.item.processResults(result);
        }

        onRequestFailed: {
            loader.item.appendToOutput("Error: " + error, true);
        }
    }

    Binding {
        target: VirtualKeyboardSettings
        property: "fullScreenMode"
        value: true
    }

    color: root.backgroundColor

    Loader {
        id: loader
        anchors.fill: parent
        source: "qrc:/welcome.qml"

        Connections {
            target: loader.item
            onWelcomed: {
                loader.source = "qrc:/challenge.qml"
            }
            onFinishedTrial: {
                loader.source = "qrc:/welcome.qml"
            }
        }

        Component.onCompleted: {
            checkEmail();
        }
    }

    MessageBox {
        id: dialogError
        title: "Some error"
        textMain: "Some error"
    }

    Dialog {
        id: dialogTerms
        anchors.centerIn: parent
        modal: true
        title: "Terms and conditions"
        width: parent.width * 0.6
        height: parent.height * 0.4

        ColumnLayout {
            anchors.fill: parent

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextArea {
                    font.pixelSize: root.secondaryFontSize
                    text: "We can do whatever and you can't do anything. We can do whatever and you can't do anything. We can do whatever and you can't do anything. We can do whatever and you can't do anything. We can do whatever and you can't do anything. We can do whatever and you can't do anything. We can do whatever and you can't do anything. We can do whatever and you can't do anything."
                    wrapMode: Text.WordWrap
                }
            }

            Button {
                Layout.alignment: Qt.AlignRight
                text: "Okay, Google"
                onClicked: {
                    dialogTerms.close();
                }
            }
        }
    }

    function checkEmail(email)
    {
        return /^[^@]+\@[^@]+$/.test(email);
    }

    function getCurrentDateTime()
    {
        return new Date().toISOString().replace(/[:|.|T]/g, "-").replace("Z", "");
    }
}

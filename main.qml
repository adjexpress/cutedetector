import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import com.amin.classes 1.0

ApplicationWindow
{
    visible: true
    width: 800
    height: 600
    title: qsTr("Cute Detector")

    CvDetectFilter
    {
        id: testFilter
        onObjectDetected:
        {
            if((w == 0) || (h == 0))
            {
                smile.visible = false;
            }
            else
            {
                var r = video.mapNormalizedRectToItem(Qt.rect(x, y, w, h));
                smile.x = r.x;
                smile.y = r.y;
                smile.width = r.width;
                smile.height = r.height;
                smile.visible = true;
            }
        }
    }

    Camera
    {
        id: camera
    }

    ShaderEffect
    {
        id: videoShader
        property variant src: video
        property variant source: video
    }

    SwipeView
    {
        id: mainSwipe
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        interactive: false

        Page
        {
            padding: 5
            GroupBox
            {
                anchors.fill: parent
                padding: 5
                ColumnLayout
                {
                    anchors.fill: parent
                    VideoOutput
                    {
                        id: video
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        source: camera
                        autoOrientation: false

                        filters: [testFilter]

                        Image
                        {
                            id: smile
                            source: "qrc:/smile.png"
                            visible: false
                        }
                    }

                    RowLayout
                    {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Label
                        {
                            text: "Camera"
                        }
                        ComboBox
                        {
                            Layout.fillWidth: true
                            model: QtMultimedia.availableCameras
                            textRole: "displayName"
                            onActivated:
                            {
                                camera.stop()
                                camera.deviceId = model[currentIndex].deviceId
                                cameraStartTimer.start()
                            }

                            Timer
                            {
                                id: cameraStartTimer; interval: 500;running: false; repeat: false; onTriggered: camera.start();
                            }

                            onAccepted:
                            {
                                console.log("aaa")
                            }
                        }
                    }
                }
            }
        }

        Page
        {
            padding: 5
            GroupBox
            {
                anchors.fill: parent
                padding: 5

                Label
                {
                    anchors.fill: parent
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    wrapMode: Label.Wrap

                    text: "This project uses haarcascade_frontalface_default.xml file for the classifier, " +
                          "which is included in the default OpenCV installation. Note that the quality of the " +
                          "classifier totally depends on how well it trained.<br>" +
                          "Refer to <a href=\"http://amin-ahmadi.com/cascade-trainer-gui\">http://amin-ahmadi.com/cascade-trainer-gui</a> on how " +
                          "to train your classifiers."

                    onLinkActivated:
                    {
                        Qt.openUrlExternally(link)
                    }
                }
            }
        }
    }

    footer: TabBar
    {
        id: tabBar
        currentIndex: mainSwipe.currentIndex
        TabButton
        {
            text: qsTr("Home")
        }
        TabButton
        {
            text: qsTr("Help")
        }
    }
}

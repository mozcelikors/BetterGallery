/**
* @author mozcelikors
**/

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt5Compat.GraphicalEffects
import com.bettergallery.helper

Window {
    id: root
    width: 1280
    height: 800
    color: "#0b1524"
    visible: true
    title: qsTr("Multimedia Player")
    //property alias source: mediaPlayer.source

    property int pageId:0

    Helper {
        id: helper
    }

    function find (model, criteria)
    {
        for(var i = 0; i < model.count; ++i)
        {
            if (criteria(model.get(i)))
                return model.get(i)
        }
        return null
    }

    function readTextFile (file)
    {
        var rawFile = new XMLHttpRequest();
        rawFile.open("GET", file, false);
        rawFile.onreadystatechange = function (){
            if (rawFile.readyState === 4) {
                if(rawFile.status === 200 || rawFile.status == 0) {
                    var allText = rawFile.responseText;
                    var lines = allText.split('\n');
                    var i;
                    /*for (i = 0; i < lines.length; i++)
                    {
                        console.log(lines[i]);
                    }
                    console.log(allText);*/
                }
            }
        }
        rawFile.send(null);
        return rawFile.responseText;
    }

    Rectangle {
        id: mainRect
        color: "#0b1524"
        width: parent.width
        height: parent.height
        anchors.fill:parent
        opacity: (pageId==0)?1:0
        z:(pageId==0)?2:0

        Behavior on opacity {
            SpringAnimation {
                spring:2;
                damping:0.2;
            }
        }

        Component.onCompleted: {
            var names, ids, i;
            names = readTextFile("file://"+BETTERGALLERYDIR+"/out/names_sorted.txt")
            ids = readTextFile("file://"+BETTERGALLERYDIR+"/out/ids_sorted.txt")
            var names_arr = names.split('\n');
            console.log(names_arr[2]);
            var ids_arr = ids.split('\n');
            console.log(ids_arr[2]);
            for (i = 0; i < names_arr.length; i++)
            {
                gamesListModel.append({gameId: ids_arr[i]*1, gameName:names_arr[i]});
            }

        }

        property string lastGameName : "Test"

        ListView {
            id:games
            width: parent.width
            height: parent.height-400
            model: gamesListModel
            anchors.fill:parent
            anchors.leftMargin:100
            anchors.rightMargin:100
            anchors.topMargin:220
            orientation: ListView.Horizontal
            highlightMoveDuration: 100
            highlightMoveVelocity: -1
            focus: (pageId==0)?true:false
            Keys.onPressed: (event)=>{
                if (event.key === Qt.Key_Return)
                {
                    console.log("enter");
                    if (pageId == 0)
                    {
                        pageId = 1;
                        console.log("pageId=1");
                        var gameIdToBeLoaded = gamesListModel.get(games.currentIndex).gameId;
                        console.log("GameIdToBeLoaded" + gameIdToBeLoaded);
                        screenshots.load(gameIdToBeLoaded);
                    }
                }
            }

            delegate: Item {
                id: item
                width:460
                height:215
                property int indexOfThisDelegate: index
                Column {
                    scale: (games.currentIndex === item.indexOfThisDelegate)?1.2:0.8
                    Image {
                       id: img
                       source:  "file://"+BETTERGALLERYDIR+"/out/bettergallery_headers/"+gameId+".jpg"
                       width: 460
                       height: 215


                       onStatusChanged: {
                            if(img.status === Image.Error)
                            {
                                //img.source = "file://"+"/home/deck/.local/share/Steam/userdata/"+STEAMUSERID+"/config/grid/"+gameId+".jpg"
                                //img.source = "file://"+BETTERGALLERYDIR+"/placeholder.png";
                                var ssPath = "file://"+BETTERGALLERYDIR+"/out/bettergallery_gamedata/"+gameId+".txt";
                                var ssFiles = readTextFile(ssPath)
                                var ssFiles_arr = ssFiles.split('\n');
                                img.source = "file://"+ssFiles_arr[0];
                            }
                       }
                       MouseArea {
                           anchors.fill:parent
                           onClicked:{
                                pageId = 1;
                                console.log("pageId=1");
                                games.currentIndex = item.indexOfThisDelegate;
                                var gameIdToBeLoaded = gamesListModel.get(games.currentIndex).gameId;
                                console.log("GameIdToBeLoaded" + gameIdToBeLoaded);
                                screenshots.load(gameIdToBeLoaded);

                           }
                      }
                    }
                    Item {
                        opacity:(games.currentIndex === item.indexOfThisDelegate)?0.2:0.05
                        width: 460
                        height: 215
                        Behavior on opacity {
                            SpringAnimation {
                                spring:2;
                                damping: 0.2;
                            }
                        }
                        Image {
                            id: imgReflection
                            source: img.source
                            width: 460
                            height: 215
                            rotation:180

                            mirror:true



                            // QML Skew Transformation
                            transform: Matrix4x4 {
                                property real a: Math.PI / 8 //-Math.sin(a)
                                matrix: Qt.matrix4x4(1, Math.tan(a),       0,      8,
                                                     0,           3/4,     0,      8,
                                                     0,           0,      3/4,     0,
                                                     0,           0,       0,      1)
                            }

                            OpacityMask {
                                source: mask
                                maskSource: imgReflection
                            }

                            LinearGradient {
                                id: mask
                                anchors.fill: parent
                                gradient: Gradient {
                                    GradientStop { position: 0.2; color: "#0b1524"; }
                                    GradientStop { position: 0.5; color: "#0b1524"; }
                                    GradientStop { position: 0.9; color: "transparent"}
                                }
                            }
                        }
                    }


                    /*Text {
                        anchors.horizontalCenter: img.horizontalCenter
                        text: gameName
                        color: "white"
                        font.pixelSize:25
                    }*/

                    Behavior on scale {
                        SpringAnimation {
                            spring:2;
                            damping: 0.2;
                        }
                    }
                }

            }
        }



        ListModel {
            id:gamesListModel
            /*ListElement {gameId:1098080; gameName:"3000th Duel"}*/
        }

    }

    Rectangle {
            id: screenshotRect
            color: "#0b1524"
            width: parent.width
            height: parent.height
            anchors.fill:parent
            opacity:(pageId==1 || pageId==2)?1:0
            z:(pageId==1 || pageId==2)?2:0
            Behavior on opacity
            {
                SpringAnimation {
                    spring:2;
                    damping: 0.2;
                }
            }
            ListView {
                id:screenshots
                width: parent.width
                height: (pageId != 2)?parent.height-400:parent.height
                model: screenshotsListModel
                anchors.fill:parent
                anchors.leftMargin:(pageId != 2)?100:0
                anchors.rightMargin:(pageId != 2)?100:0
                anchors.topMargin:(pageId != 2)?170:0
                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
                highlightMoveDuration: 100
                highlightMoveVelocity: -1
                highlightRangeMode: ListView.StrictlyEnforceRange
                spacing:(pageId != 2)?100:0

                function load (gameIdToBeLoaded){
                    var names, ids, i;
                    var ssPath = "file://"+BETTERGALLERYDIR+"/out/bettergallery_gamedata/"+gameIdToBeLoaded+".txt";
                    var ssFiles = readTextFile(ssPath)
                    console.log("ssPath: " + ssPath);
                    console.log("ssFiles: " + ssFiles);
                    var ssFiles_arr = ssFiles.split('\n');
                    for (i = 0; i < ssFiles_arr.length - 1; i++)
                    {
                        //console.log(ssFiles_arr[i]);
                        screenshotsListModel.append({gameId: gameIdToBeLoaded*1, filePath:ssFiles_arr[i]});
                    }
                }
                function deleteCurrentScreenshot()
                {
                    screenshots.highlightMoveDuration = 1;
                    var gameId = screenshotsListModel.get(screenshots.currentIndex).gameId;
                    console.log("GAME ID "+gameId);
                    helper.removeFile(gameId, screenshotsListModel.get(screenshots.currentIndex).filePath);
                    var previousIdx = screenshots.currentIndex;
                    screenshotsListModel.clear();
                    screenshots.load(gameId);
                    if (previousIdx > 0)
                        screenshots.currentIndex = previousIdx-1;
                    else
                        screenshots.currentIndex = 0;
                    screenshots.highlightMoveDuration = 100;
                }

                focus: (pageId==1 || pageId==2)?true:false
                Keys.onPressed: (event)=>{
                    if (event.key === Qt.Key_Delete)
                    {
                        deleteCurrentScreenshot();
                    }
                    else if (event.key === Qt.Key_Backspace)
                    {
                        if (pageId == 1)
                        {
                            screenshotsListModel.clear();
                        }
                         console.log("backspace");
                         if (pageId > 0)
                             pageId = pageId - 1;

                    }
                    else if (event.key === Qt.Key_Return)
                    {
                        console.log("enter");
                        if (pageId == 1)
                        {
                            pageId = 2;
                        }
                    }
                }

                delegate: Item {
                    id: item1
                    width:(pageId != 2)?1280*0.4:1280
                    height:(pageId != 2)?800*0.4:800
                    property int indexOfThisDelegate: index
                    Column {
                        scale: {
                            if (pageId == 2){
                                return 1.0;
                            }
                            else
                            {
                                if (screenshots.currentIndex === item1.indexOfThisDelegate)
                                {
                                    return 1.3;
                                }
                                else
                                {
                                    return 0.8;
                                }
                            }
                        }

                        Image {
                           id: img1
                           source: "file://"+filePath
                           width: (pageId != 2)?1280*0.4:1280
                           height: (pageId != 2)?800*0.4:800

                           MouseArea {
                                anchors.fill:parent
                                onClicked:{
                                     screenshots.currentIndex = item1.indexOfThisDelegate;
                                     pageId = 2;
                                }
                           }
                        }
                    }
                }
            }

            ListModel {
                id:screenshotsListModel
                /*ListElement {gameId:1098080; filePath:"3000th Duel"}*/
            }
    }

    Text {
        id: gameNameText
        text: gamesListModel.get(games.currentIndex).gameName
        color: "white"
        opacity:(pageId<2)?0.7:0
        z:4
        font.pixelSize:50
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: mainRect.horizontalCenter
    }

    Text {
        id: xText
        text: (pageId == 0)?"✖":"↩"
        color: "white"
        opacity:(pageId >= 0) ?0.7:0
        z:4
        font.pixelSize:50
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: 50
        anchors.left: mainRect.left
        anchors.leftMargin: 60
        MouseArea
        {
            anchors.fill:parent
            onClicked: {
                if (pageId == 0)
                {
                    Qt.quit();
                }
                if (pageId == 1)
                {
                    screenshotsListModel.clear();
                }
                if (pageId > 0)
                    pageId = pageId - 1;
            }
        }
    }

    Text {
        text: "🗑"
        color: "white"
        opacity:(pageId == 1)?0.7:0
        z:4
        font.pixelSize:40
        anchors.bottom: mainRect.bottom
        anchors.right: mainRect.right
        anchors.rightMargin: 60
        anchors.bottomMargin: 50
        MouseArea
        {
            anchors.fill:parent
            onClicked: {
                screenshots.deleteCurrentScreenshot();
            }
        }
    }
}

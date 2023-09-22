/**
* @author mozcelikors
**/

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia


Window {
    id: root
    width: 1280
    height: 720
    color: "#0b1524"
    visible: true
    title: qsTr("Multimedia Player")
    //property alias source: mediaPlayer.source

    property int pageId:0

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
            names = readTextFile("file://"+BETTERGALLERYDIR+"/out/names.txt")
            ids = readTextFile("file://"+BETTERGALLERYDIR+"/out/ids.txt")
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
            anchors.topMargin:200
            orientation: ListView.Horizontal
            highlightMoveDuration: 100
            highlightMoveVelocity: -1
            focus: (pageId==0)?true:false
            Keys.onPressed: (event)=>{
                if (event.key === Qt.Key_Backspace)
                {
                     console.log("backspace");
                     Qt.quit();
                }
                else if (event.key === Qt.Key_Return)
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
                width:200
                height:225
                property int indexOfThisDelegate: index

                Column {
                    scale: (games.currentIndex === item.indexOfThisDelegate)?1.3:0.8
                    Image {
                       id: img
                       source: "file://"+"/home/deck/.local/share/Steam/userdata/"+STEAMUSERID+"/config/grid/"+gameId+"p.jpg"
                       width: 150*1.2
                       height: 225*1.2
                       onStatusChanged: {
                            if(img.status === Image.Error)
                            {
                                img.source = "file://"+BETTERGALLERYDIR+"/placeholder.png";
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
                anchors.topMargin:(pageId != 2)?100:0
                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
                highlightMoveDuration: 100
                highlightMoveVelocity: -1
                highlightRangeMode: ListView.StrictlyEnforceRange
                spacing:(pageId != 2)?250:0
                function load (gameIdToBeLoaded){
                    var names, ids, i;
                    var ssPath = "file://"+BETTERGALLERYDIR+"/out/bettergallery_gamedata/"+gameIdToBeLoaded+".txt";
                    var ssFiles = readTextFile(ssPath)
                    console.log("ssPath: " + ssPath);
                    console.log("ssFiles: " + ssFiles);
                    var ssFiles_arr = ssFiles.split('\n');
                    for (i = 0; i < ssFiles_arr.length; i++)
                    {
                        //console.log(ssFiles_arr[i]);
                        screenshotsListModel.append({gameId: gameIdToBeLoaded*1, filePath:ssFiles_arr[i]});
                    }
                }

                focus: (pageId==1 || pageId==2)?true:false
                Keys.onPressed: (event)=>{
                    if (event.key === Qt.Key_Backspace)
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
                    width:(pageId != 2)?640*0.5:1280
                    height:(pageId != 2)?480*0.5:720
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
                        //(screenshots.currentIndex === item1.indexOfThisDelegate)?1.3:0.8
                        Image {
                           id: img1
                           source: "file://"+filePath
                           width: (pageId != 2)?640*0.8:1280
                           height: (pageId != 2)?480*0.8:720

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
        text: gamesListModel.get(games.currentIndex).gameName
        color: "white"
        opacity:(pageId<2)?0.4:0
        z:4
        font.pixelSize:60
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: 100
        anchors.horizontalCenter: mainRect.horizontalCenter
    }

    Text {
        text: (pageId == 0)?"✖":"↩"
        color: "white"
        opacity:(pageId >= 0) ?0.7:0
        z:4
        font.pixelSize:50
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: 30
        anchors.left: mainRect.left
        anchors.leftMargin: 30
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
}

import QtQuick 1.1
import com.nokia.meego 1.1

Page {
    id: page
    //orientationLock: PageOrientation.LockLandscape
    tools: commonTools

    property int winCount: 0;
    property int lossCount: 0;
    property int drawCount: 0;
    property int gamesPlayed: 0;

    function loadState() {
        var db = openDatabaseSync("RockEtc", "", "Statistics of RockEtc", 10000,
                                  function (newdb) {
                                      newdb.transaction(
                                                  function(tx){
                                                      tx.executeSql('CREATE TABLE IF NOT EXISTS Statistics(winCount NUMBER, lossCount NUMBER, drawCount NUMBER, gamesPlayed NUMBER)');
                                                  })
                                  }
                                      );
        db.readTransaction(
                    function (tx) {
                        var rs = tx.executeSql("SELECT * FROM Statistics")
                        if (rs.rows.length > 0) {
                            winCount = rs.rows.item(0).winCount;
                            lossCount = rs.rows.item(0).lossCount;
                            drawCount = rs.rows.item(0).drawCount;
                            gamesPlayed = rs.rows.item(0).gamesPlayed;
                        }
                    }
                    )
    }

    Component.onCompleted: loadState()

    Component.onDestruction: saveState()

    function saveState() {
        var db = openDatabaseSync("RockEtc", "", "Statistics of RockEtc", 10000);
        db.transaction(
                    function(tx){
                        //tx.executeSql('CREATE TABLE IF NOT EXISTS Statistics(winCount NUMBER, lossCount NUMBER, drawCount NUMBER, gamesPlayed NUMBER)');
                        //var rs = tx.executeSql('SELECT COUNT(*) AS rowCount FROM Statistics')
                        //if (rs.rows.item(0).rowCount > 0)
                        //    tx.executeSql('UPDATE TABLE Statistics SET winCount=?, lossCount=?, drawCount=?, gamesPlayed=?', [winCount, lossCount, drawCount, gamesPlayed])
                        //else
                            tx.executeSql('INSERT OR REPLACE INTO Statistics VALUES(?, ?, ?, ?)', [winCount, lossCount, drawCount, gamesPlayed])
                    }
                        )
    }

    function chosen(number) {
        var you = number;
        var me = Math.floor(Math.random() * 3);
        var newstate;
        switch (you) {
        case 0:
            yourchoice.source = "rock.svg"
            break;
        case 1:
            yourchoice.source = "scissors.svg"
            break;
        case 2:
            yourchoice.source = "paper.svg"
            break;
        }
        switch (me) {
        case 0:
            mychoice.source = "rock.svg"
            break;
        case 1:
            mychoice.source = "scissors.svg"
            break;
        case 2:
            mychoice.source = "paper.svg"
            break;
        }
        if (you == me) {
            newstate = "Draw"
            drawCount++;
            switch (you) {
            case 0:
                result.message = "We both chose Rock. It's a draw."
                break;
            case 1:
                result.message = "We both chose Scissors. It's a draw."
                break;
            case 2:
                result.message = "We both chose Paper. It's a draw."
                break;
            }
        } else {
            switch (you) {
            case 0:
                if (me == 1) {
                    newstate = "Win"
                    winCount++;
                    result.message = "You chose Rock. I chose Scissors. You win."
                } else {
                    newstate = "Lose"
                    lossCount++;
                    result.message = "You chose Rock. I chose Paper. I win."
                }
                break;
            case 1:
                if (me == 2) {
                    newstate = "Win"
                    winCount++;
                    result.message = "You chose Scissors. I chose Paper. You win."
                } else {
                    newstate = "Lose"
                    lossCount++;
                    result.message = "You chose Scissors. I chose Rock. I win."
                }
                break;
            case 2:
                if (me == 0) {
                    newstate = "Win"
                    winCount++;
                    result.message = "You chose Paper. I chose Rock. You win."
                } else {
                    newstate = "Lose"
                    lossCount++;
                    result.message = "You chose Paper. I chose Scissors. I win."
                }
                break;
            }
        }
        //result.open();
        gamesPlayed++;
        return newstate;
    }

    Timer {
        id: reset
        interval: 3000
        running: false
        repeat: false
        onTriggered: page.state = ''
    }

    QueryDialog {
        id: result
        titleText: qsTr("Result")
        acceptButtonText: qsTr("Play again")
        onAccepted: page.state = ''
    }

    Rectangle {
        id: statusrect
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: status.height
        color: "#ffffff"
        Label {
            id: status
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Player make your choice"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Row {
        id: row1
        anchors.top: statusrect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: stats.bottom
        Column {
            id: column1
            width: parent.width / 4
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //opacity: page.state == "" ? 1.0 : 0.0
            Label {
                id: playerlabel
                text: "Player"
                horizontalAlignment: Text.AlignLeft
            }

            Rectangle {
                id: rockrect
                radius: 8
                color: "yellow"
                anchors.margins: 4
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height / 3 - playerlabel.height
                opacity: 1.0

            Image {
                id: yourrock
                //height: parent.height / 3 - playerlabel.height
                //anchors.right: parent.right
                //anchors.left: parent.left
                anchors.fill: parent
                anchors.margins: 4
                fillMode: Image.PreserveAspectFit
                source: "rock.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: if (page.state == "") page.state = chosen(0)
                }
            }
            }            

            Rectangle {
                id: scissorsrect
                radius: 8
                color: "yellow"
                anchors.margins: 4
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height / 3 - playerlabel.height
                opacity: 1.0

            Image {
                id: yourscissors
                //height: parent.height / 3 - playerlabel.height
                //anchors.right: parent.right
                //anchors.left: parent.left
                anchors.fill: parent
                anchors.margins: 4
                fillMode: Image.PreserveAspectFit
                source: "scissors.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: if (page.state == "") page.state = chosen(1)
                }
            }
            }

            Rectangle {
                id: paperrect
                radius: 8
                color: "yellow"
                anchors.margins: 4
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height / 3 - playerlabel.height
                opacity: 1.0

            Image {
                id: yourpaper
                //height: parent.height / 3 - playerlabel.height
                //anchors.right: parent.right
                //anchors.left: parent.left
                anchors.fill: parent
                anchors.margins: 4
                fillMode: Image.PreserveAspectFit
                source: "paper.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: if (page.state == "") page.state = chosen(2)
                }
            }
            }
        }
        /* Column {
            width: parent.width / 2
            height: parent.height

            Row { */
                Rectangle {
                    id: yourrect
                    color: "#ffffff"
                    width: parent.width / 4
                    height: parent.height
                    Image {
                        id: yourchoice
                        fillMode: Image.PreserveAspectFit
                        anchors.fill: parent
                        opacity: 0.0
                        Behavior on opacity {
                            NumberAnimation { duration: 1000 }
                        }
                    }
                }
                Rectangle {
                    id: myrect
                    color: "#ffffff"
                    width: parent.width / 4
                    height: parent.height
                    Image {
                        id: mychoice
                        fillMode: Image.PreserveAspectFit
                        anchors.fill: parent
                        opacity: 0.0
                        mirror: true
                        Behavior on opacity {
                            NumberAnimation { duration: 1000 }
                        }
                    }
                }
            /* }
        } */
        Column {
            id: column2
            width: parent.width / 4
            //opacity: page.state == "" ? 0.5 : 0.0
            anchors.bottom: parent.bottom
            anchors.top: parent.top

            Label {
                id: computerlabel
                text: "Computer"
                horizontalAlignment: Text.AlignRight
                anchors.left: parent.left
                anchors.right: parent.right
            }

            Image {
                id: myrock
                height: parent.height / 3 - computerlabel.height
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.left: parent.left
                source: "rock.svg"
                mirror: true
                opacity: page.state == "" ? 1.0 : 0.0
            }
            Image {
                id: myscissors
                height: parent.height / 3 - computerlabel.height
                anchors.right: parent.right
                anchors.left: parent.left
                fillMode: Image.PreserveAspectFit
                source: "scissors.svg"
                mirror: true
                opacity: page.state == "" ? 1.0 : 0.0
            }
            Image {
                id: mypaper
                height: parent.height / 3 - computerlabel.height
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.left: parent.left
                source: "paper.svg"
                mirror: true
                opacity: page.state == "" ? 1.0 : 0.0
            }
        }
    }

    Row {
        id: stats
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        Rectangle {
            id: winsbox
            color: "#66ff66"
            width: gamesPlayed == 0 ? parent.width / 3 : parent.width * (winCount / gamesPlayed)
            height: Math.max(winstext.height, Math.max(drawstext.height, lossestext.height))
            Label {
                id: winstext
                text: winCount + " win" + (winCount != 1 ? "s" : "")
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                anchors.right: parent.right
                visible: gamesPlayed == 0 || winCount > 0
            }
            Behavior on width {
                NumberAnimation { duration: 1000 }
            }
        }
        Rectangle {
            id: drawsbox
            color: "#6666ff"
            width: gamesPlayed == 0 ? parent.width / 3 : parent.width * (drawCount / gamesPlayed)
            height: Math.max(drawstext.height, Math.max(winstext.height, lossestext.height))
            Label {
                id: drawstext
                text: drawCount + " draw" + (drawCount != 1 ? "s" : "")
                horizontalAlignment: Text.AlignHCenter
                anchors.left: parent.left
                anchors.right: parent.right
                visible: gamesPlayed == 0 || drawCount > 0
            }
            Behavior on width {
                NumberAnimation { duration: 1000 }
            }
        }
        Rectangle {
            id: lossesbox
            color: "#ff6666"
            width: gamesPlayed == 0 ? parent.width / 3 : parent.width * (lossCount / gamesPlayed)
            height: Math.max(lossestext.height, Math.max(winstext.height, drawstext.height))
            Label {
                id: lossestext
                text: lossCount + " loss" + (lossCount != 1 ? "es" : "")
                horizontalAlignment: Text.AlignRight
                anchors.left: parent.left
                anchors.right: parent.right
                visible: gamesPlayed == 0 || lossCount > 0
            }
            Behavior on width {
                NumberAnimation { duration: 1000 }
            }
        }
    }

    states: [
        State {
            name: "YouRock"

            PropertyChanges {
                target: yourchoice
                source: "rock.svg"
            }

            StateChangeScript {
                script: chosen(0);
            }
        },

        State {
            name: "YouScissors"

            PropertyChanges {
                target: yourchoice
                source: "scissors.svg"
            }

            StateChangeScript {
                script: chosen(1);
            }
        },

        State {
            name: "YouPaper"

            PropertyChanges {
                target: yourchoice
                source: "paper.svg"
            }

            StateChangeScript {
                script: chosen(2);
            }
        },

        State {
            name: "Win"

            PropertyChanges {
                target: yourrect
                color: "#66ff66"
            }

            PropertyChanges {
                target: myrect
                color: "#ff6666"
            }

            PropertyChanges {
                target: statusrect
                color: "#66ff66"
            }

            PropertyChanges {
                target: status
                text: "You win!"
            }

            PropertyChanges {
                target: mychoice
                opacity: 1.0
            }

            PropertyChanges {
                target: yourchoice
                opacity: 1.0
            }

            PropertyChanges {
                target: rockrect
                opacity: 0.0
            }

            PropertyChanges {
                target: scissorsrect
                opacity: 0.0
            }

            PropertyChanges {
                target: paperrect
                opacity: 0.0
            }

            StateChangeScript {
               script: reset.start()
            }
        },

        State {
            name: "Lose"

            PropertyChanges {
                target: yourrect
                color: "#ff6666"
            }

            PropertyChanges {
                target: myrect
                color: "#66ff66"
            }

            PropertyChanges {
                target: statusrect
                color: "#ff6666"
            }

            PropertyChanges {
                target: status
                text: "I win!"
            }

            PropertyChanges {
                target: mychoice
                opacity: 1.0
            }

            PropertyChanges {
                target: yourchoice
                opacity: 1.0
            }

            PropertyChanges {
                target: rockrect
                opacity: 0.0
            }

            PropertyChanges {
                target: scissorsrect
                opacity: 0.0
            }

            PropertyChanges {
                target: paperrect
                opacity: 0.0
            }

            StateChangeScript {
                script: reset.start()
            }
       },

       State {
            name: "Draw"

            PropertyChanges {
                target: myrect
                color: "#6666ff"
            }

            PropertyChanges {
                target: yourrect
                color: "#6666ff"
            }

            PropertyChanges {
                target: statusrect
                color: "#6666ff"
            }

            PropertyChanges {
                target: status
                text: "It's a draw."
            }

            PropertyChanges {
                target: mychoice
                opacity: 1.0
            }

            PropertyChanges {
                target: yourchoice
                opacity: 1.0
            }

            PropertyChanges {
                target: rockrect
                opacity: 0.0
            }

            PropertyChanges {
                target: scissorsrect
                opacity: 0.0
            }

            PropertyChanges {
                target: paperrect
                opacity: 0.0
            }

            StateChangeScript {
                script: reset.start()
            }
        }

    ]

    transitions: [
        Transition {
            to: "*"
            ColorAnimation {
                target: statusrect
                duration: 1000
            }
            ColorAnimation {
                target: yourrect
                duration: 1000
            }
            ColorAnimation {
                target: myrect
                duration: 1000
            }

        }

    ]

    /* Column {
        id: column1
        anchors.fill: parent

        Label {
            id: label
            text: qsTr("Make your choice")
            horizontalAlignment: Text.AlignHCenter
}
        ButtonColumn {
            id: buttoncolumn1
            anchors.right: parent.right
            anchors.left: parent.left

            Button {
                id: button1
                text: qsTr("Rock")
                onClicked: chosen(0)
            }

            Button {
                id: button2
                text: qsTr("Scissors")
                onClicked: chosen(1)
            }

            Button {
                id: button3
                text: qsTr("Paper")
                onClicked: chosen(2)
            }
        }
    } */
}

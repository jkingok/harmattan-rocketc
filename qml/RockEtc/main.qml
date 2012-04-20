import QtQuick 1.1
import com.nokia.meego 1.1

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    QueryDialog {
        id: about
        titleText: qsTr("About RockEtc")
        acceptButtonText: qsTr("Close")
        message: qsTr("A rock, paper, scissors game against the computer.\n\nJoshua King 2012")
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    function resetStatistics() {
        mainPage.gamesPlayed = 0
        mainPage.winCount = 0
        mainPage.lossCount = 0
        mainPage.drawCount = 0
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { 
                text: qsTr("About RockEtc")
                onClicked: about.open()
            }
            MenuItem {
                text: qsTr("Reset statistics")
                onClicked: resetStatistics()
            }
        }
    }
}

import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import Scanner 1.0

Window {
    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Scanner")

    Label {
        id: resultsLabel
        visible: false
        anchors.centerIn: parent
        text: qsTr("")
    }

/***
    MessageDialog {
        id: messageBox
        visible: false
        title: "Are you sure?"
        text: "dummy"
        onAccepted: {
        }
    }
***/

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        anchors.margins: 10

        TextField {
            id: host
            placeholderText: qsTr("Host")
            font.pixelSize: 12
        }

        TextField {
            id: startPort
            placeholderText: qsTr("Start Port")
            font.pixelSize: 12
        }

        TextField {
            id: endPort
            placeholderText: qsTr("End Port")
            font.pixelSize: 12
        }

        TextField {
            id: timeout
            placeholderText: qsTr("Timeout (35)")
            font.pixelSize: 12
        }

        TextField {
            id: type
            placeholderText: qsTr("Scan Type (SYN)")
            font.pixelSize: 12
        }
    }

    Button {
        id: getResults
        anchors.top: layout.bottom
        text: qsTr("Results")

        onClicked: {
            resultsLabel.text = ""; /* Clear out the text */

            layout.visible = false;
            getResults.visible = false;
            resultsLabel.visible = true;
            backButton.visible = true;

            /* Set exit button */
            exitButton.anchors.top = backButton.bottom;

            /* Run the scan thread after killing the previous one */
            rubyScanner.kill_thread();
            rubyScanner.run();
        }
    }

    Button {
        id: backButton
        visible: false
        anchors.top: resultsLabel.bottom
        text: qsTr("Back")

        onClicked: {
            layout.visible = true;
            getResults.visible = true;
            resultsLabel.visible = false;
            backButton.visible = false;

            /* Clear the resultsLabel and kill scan thread */
            resultsLabel.text = "";
            rubyScanner.kill_thread();

            /* Set exit button */
            exitButton.anchors.top = getResults.bottom;
        }
    }

    Button {
        id: exitButton
        visible: true
        anchors.top: getResults.bottom
        text: qsTr("Exit")

        onClicked: {
            rubyScanner.quit();
        }
    }

    RubyScanner {
        /* Define the source of access on properties */
        id: rubyScanner
        inputHost: host.text
        inputStartPort: startPort.text
        inputEndPort: endPort.text
        inputTimeout: timeout.text
        inputType: type.text

        /* Define signal action on a javascript command */
        /* TODO: Javascript function to oneliner converter TODO */
        onPortOpen: resultsLabel.text += "[+] " + host.text + " | Port: " + currentPort + "/open\n"
        onPortFiltered: resultsLabel.text += "[+] " + host.text + "| Port: " + currentPort + "/filtered\n"
        onEndOfScan: resultsLabel.text += "End of scan\n"
    }
}

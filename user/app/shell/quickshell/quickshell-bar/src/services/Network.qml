pragma Singleton
pragma ComponentBehavior: Bound

// Taken from https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/services/Network.qml

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool wifi: true
    property bool ethernet: false

    property bool wifiEnabled: false
    property bool wifiScanning: false
    property bool wifiConnecting: connectProc.running
    property WifiAccessPoint wifiConnectTarget
    readonly property list<WifiAccessPoint> wifiNetworks: []
    readonly property WifiAccessPoint active: wifiNetworks.find(n => n.active) ?? null
    property string wifiStatus: "disconnected"

    property string networkName: ""
    property int networkStrength
    property string materialSymbol: ethernet ? "lan" : !wifiEnabled ? "signal_wifi_off" : wifiStatus === "connecting" ? "signal_wifi_statusbar_not_connected" : wifiStatus === "disconnected" ? "wifi_find" : wifiStatus === "disabled" ? "signal_wifi_off" : wifi ? (networkStrength > 83 ? "signal_wifi_4_bar" : networkStrength > 67 ? "network_wifi" : networkStrength > 50 ? "network_wifi_3_bar" : networkStrength > 33 ? "network_wifi_2_bar" : networkStrength > 17 ? "network_wifi_1_bar" : "signal_wifi_0_bar") : "signal_wifi_bad"

    function getStrengthIcon(strength: int): string {
        if (strength > 83)
            return "signal_wifi_4_bar";
        if (strength > 67)
            return "network_wifi";
        if (strength > 50)
            return "network_wifi_3_bar";
        if (strength > 33)
            return "network_wifi_2_bar";
        if (strength > 17)
            return "network_wifi_1_bar";
        return "signal_wifi_0_bar";
    }

    function enableWifi(enabled = true): void {
        const cmd = enabled ? "on" : "off";
        enableWifiProc.exec(["nmcli", "radio", "wifi", cmd]);
    }

    function toggleWifi(): void {
        enableWifi(!wifiEnabled);
    }

    function rescanWifi(): void {
        wifiScanning = true;
        rescanProcess.running = true;
    }

    function connectToWifiNetwork(accessPoint: WifiAccessPoint): void {
        accessPoint.askingPassword = false;
        root.wifiConnectTarget = accessPoint;
        // We use this instead of `nmcli connection up SSID` because this also creates a connection profile
        connectProc.exec(["nmcli", "dev", "wifi", "connect", accessPoint.ssid]);
    }

    function disconnectWifiNetwork(): void {
        if (active)
            disconnectProc.exec(["nmcli", "connection", "down", active.ssid]);
    }

    function openPublicWifiPortal() {
        Quickshell.execDetached(["xdg-open", "https://nmcheck.gnome.org/"]); // From some StackExchange thread, seems to work
    }

    function changePassword(network: WifiAccessPoint, password: string, username = ""): void {
        // TODO: enterprise wifi with username
        //
        print(password);
        print(network.ssid);
        network.askingPassword = false;
        changePasswordProc.exec({
            "environment": {
                "PASSWORD": password
            },
            "command": ["bash", "-c", `nmcli connection modify ${network.ssid} wifi-sec.psk "$PASSWORD"`]
        });
    }

    function removeConnection(network: WifiAccessPoint) {
        removeConnectionProc.exec(["nmcli", "connection", "delete", network.ssid]);
    }

    Process {
        id: removeConnectionProc

        stdout: SplitParser {
            onRead: getNetworks.running = true
        }
    }

    Process {
        id: enableWifiProc
        command: [""]
    }

    Process {
        id: connectProc
        environment: ({
                LANG: "C",
                LC_ALL: "C"
            })
        stdout: SplitParser {
            onRead: line => {
                // print(line)
                getNetworks.running = true;
            }
        }
        stderr: SplitParser {
            onRead: line => {
                print("err:", line);
                if (line.includes("Secrets were required")) {
                    root.wifiConnectTarget.askingPassword = true;
                }
            }
        }
        // onExited: (exitCode, exitStatus) => {
        //     root.wifiConnectTarget.askingPassword = (exitCode !== 0);
        // }
    }

    Process {
        id: disconnectProc
        stdout: SplitParser {
            onRead: getNetworks.running = true
        }
    }

    Process {
        id: changePasswordProc
        onExited: {
            // Re-attempt connection after changing password
            connectProc.running = false;
            connectProc.running = true;
        }
    }

    Process {
        id: rescanProcess
        command: ["nmcli", "dev", "wifi", "list", "--rescan", "yes"]
        stdout: SplitParser {
            onRead: {
                wifiScanning = false;
                getNetworks.running = true;
            }
        }
    }

    // Status update
    function update() {
        updateConnectionType.startCheck();
        wifiStatusProcess.running = true;
        updateNetworkName.running = true;
        updateNetworkStrength.running = true;
    }

    Process {
        id: subscriber
        running: true
        command: ["nmcli", "monitor"]
        stdout: SplitParser {
            onRead: root.update()
        }
    }

    Process {
        id: updateConnectionType
        property string buffer
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE d status && nmcli -t -f CONNECTIVITY g"]
        running: true
        function startCheck() {
            buffer = "";
            updateConnectionType.running = true;
        }
        stdout: SplitParser {
            onRead: data => {
                updateConnectionType.buffer += data + "\n";
            }
        }
        onExited: (exitCode, exitStatus) => {
            const lines = updateConnectionType.buffer.trim().split('\n');
            const connectivity = lines.pop(); // none, limited, full
            let hasEthernet = false;
            let hasWifi = false;
            let wifiStatus = "disconnected";
            lines.forEach(line => {
                if (line.includes("ethernet") && line.includes("connected"))
                    hasEthernet = true;
                else if (line.includes("wifi:")) {
                    if (line.includes("disconnected")) {
                        wifiStatus = "disconnected";
                    } else if (line.includes("connected")) {
                        hasWifi = true;
                        wifiStatus = "connected";

                        if (connectivity === "limited") {
                            hasWifi = false;
                            wifiStatus = "limited";
                        }
                    } else if (line.includes("connecting")) {
                        wifiStatus = "connecting";
                    } else if (line.includes("unavailable")) {
                        wifiStatus = "disabled";
                    }
                }
            });
            root.wifiStatus = wifiStatus;
            root.ethernet = hasEthernet;
            root.wifi = hasWifi;
        }
    }

    Process {
        id: updateNetworkName
        command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.networkName = data;
            }
        }
    }

    Process {
        id: updateNetworkStrength
        running: true
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"]
        stdout: SplitParser {
            onRead: data => {
                root.networkStrength = parseInt(data);
            }
        }
    }

    Process {
        id: wifiStatusProcess
        command: ["nmcli", "radio", "wifi"]
        Component.onCompleted: running = true
        environment: ({
                LANG: "C",
                LC_ALL: "C"
            })
        stdout: StdioCollector {
            onStreamFinished: {
                root.wifiEnabled = text.trim() === "enabled";
            }
        }
    }

    Process {
        id: getNetworks
        running: true
        command: ["sh", "-c", "nmcli -g ACTIVE,SIGNAL,FREQ,SSID,BSSID,SECURITY d w && echo '---SEPARATOR---' && nmcli -g NAME connection show"]
        environment: ({
                LANG: "C",
                LC_ALL: "C"
            })
        stdout: StdioCollector {
            onStreamFinished: {
                const PLACEHOLDER = "STRINGWHICHHOPEFULLYWONTBEUSED";
                const rep = new RegExp("\\\\:", "g");
                const rep2 = new RegExp(PLACEHOLDER, "g");

                const parts = text.split('---SEPARATOR---');
                const networksText = parts[0].trim();
                const knownConnections = parts[1] ? parts[1].trim().split("\n").filter(n => n.length > 0) : [];

                const allNetworks = networksText.split("\n").map(n => {
                    const net = n.replace(rep, PLACEHOLDER).split(":");
                    const ssid = net[3];
                    return {
                        active: net[0] === "yes",
                        strength: parseInt(net[1]),
                        frequency: parseInt(net[2]),
                        ssid: ssid,
                        bssid: net[4]?.replace(rep2, ":") ?? "",
                        security: net[5] || "",
                        known: knownConnections.includes(ssid)
                    };
                }).filter(n => n.ssid && n.ssid.length > 0);

                const networkMap = new Map();
                for (const network of allNetworks) {
                    const existing = networkMap.get(network.ssid);
                    if (!existing) {
                        networkMap.set(network.ssid, network);
                    } else {
                        // Prioritize active/connected networks
                        if (network.active && !existing.active) {
                            networkMap.set(network.ssid, network);
                        } else if (!network.active && !existing.active) {
                            // If both are inactive, keep the one with better signal
                            if (network.strength > existing.strength) {
                                networkMap.set(network.ssid, network);
                            }
                        }
                        // If existing is active and new is not, keep existing
                    }
                }

                const wifiNetworks = Array.from(networkMap.values());
                const rNetworks = root.wifiNetworks;
                const destroyed = rNetworks.filter(rn => !wifiNetworks.find(n => n.frequency === rn.frequency && n.ssid === rn.ssid && n.bssid === rn.bssid));
                for (const network of destroyed)
                    rNetworks.splice(rNetworks.indexOf(network), 1).forEach(n => n.destroy());
                for (const network of wifiNetworks) {
                    const match = rNetworks.find(n => n.frequency === network.frequency && n.ssid === network.ssid && n.bssid === network.bssid);
                    if (match) {
                        match.lastIpcObject = network;
                    } else {
                        rNetworks.push(apComp.createObject(root, {
                            lastIpcObject: network
                        }));
                    }
                }
            }
        }
    }

    component WifiAccessPoint: QtObject {
        required property var lastIpcObject
        readonly property string ssid: lastIpcObject.ssid
        readonly property string bssid: lastIpcObject.bssid
        readonly property int strength: lastIpcObject.strength
        readonly property int frequency: lastIpcObject.frequency
        readonly property bool active: lastIpcObject.active
        readonly property string security: lastIpcObject.security
        readonly property bool isSecure: security.length > 0
        readonly property bool known: lastIpcObject.known

        property bool askingPassword: false
    }

    Component {
        id: apComp

        WifiAccessPoint {}
    }
}

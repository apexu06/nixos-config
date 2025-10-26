pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice?.percentage ?? 1
    readonly property bool allowAutomaticSuspend: false

    property bool isLow: available && (percentage <= 10 / 100)
    property bool isCritical: available && (percentage <= 20 / 100)
    property bool isSuspending: available && (percentage <= 50 / 100)
    property bool isFull: available && (percentage >= 90 / 100)

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging
    property bool isSuspendingAndNotCharging: allowAutomaticSuspend && isSuspending && !isCharging
    property bool isFullAndCharging: isFull && isCharging

    property real energyRate: UPower.displayDevice.changeRate
    property real timeToEmpty: UPower.displayDevice.timeToEmpty
    property real timeToFull: UPower.displayDevice.timeToFull

    function getBatteryIcon() {
        if (percentage >= 0.9)
            return isCharging ? "battery_charging_full" : "battery_full";
        if (percentage >= 0.8)
            return isCharging ? "battery_charging_90" : "battery_6_bar";
        if (percentage >= 0.7)
            return isCharging ? "battery_charging_80" : "battery_5_bar";
        if (percentage >= 0.6)
            return isCharging ? "battery_charging_60" : "battery_4_bar";
        if (percentage >= 0.5)
            return isCharging ? "battery_charging_50" : "battery_3_bar";
        if (percentage >= 0.3)
            return isCharging ? "battery_charging_30" : "battery_2_bar";
        if (percentage >= 0.2)
            return isCharging ? "battery_charging_20" : "battery_1_bar";
        if (!isCharging)
            return "battery_0_bar";
    }

    function getTimeRemainingText() {

    }

    onIsLowAndNotChargingChanged: {
        if (!root.available || !isLowAndNotCharging)
            return;
        Quickshell.execDetached(["notify-send", "Low battery", "Consider plugging in your device", "-u", "critical", "-a", "Shell"]);
    }

    onIsCriticalAndNotChargingChanged: {
        if (!root.available || !isCriticalAndNotCharging)
            return;
        Quickshell.execDetached(["notify-send", "Critically low battery", "Please charge!\nAutomatic suspend triggers at %1%", "-u", "critical", "-a", "Shell"]);
    }

    onIsSuspendingAndNotChargingChanged: {
        if (root.available && isSuspendingAndNotCharging) {
            Quickshell.execDetached(["bash", "-c", `systemctl suspend || loginctl suspend`]);
        }
    }

    onIsFullAndChargingChanged: {
        if (!root.available || !isFullAndCharging)
            return;
        Quickshell.execDetached(["notify-send", "Battery full", "Please unplug the charger", "-a", "Shell"]);
    }
}

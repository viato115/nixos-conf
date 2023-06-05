#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>
#include <dbus/dbus.h>
    
enum Orientation { Undefined, Normal, RightUp, LeftUp, BottomUp };

DBusError error;
char* output = "eDP-1";
char* touch_yoga = "wacom-hid-51f8-finger";
char* pen_yoga = "wacom-hid-51f8-pen";

void dbus_disconnect(DBusConnection* connection) {
    dbus_connection_flush(connection);
    dbus_connection_close(connection);
    dbus_connection_unref(connection);
    dbus_error_free(&error);
}

DBusConnection* dbus_connect() {
    dbus_error_init(&error);
    DBusConnection* connection = dbus_bus_get(DBUS_BUS_SYSTEM, &error);
    if (connection != NULL) {
        DBusMessage* msg = dbus_message_new_method_call(
            "net.hadess.SensorProxy", "/net/hadess/SensorProxy",
            "net.hadess.SensorProxy", "ClaimAccelerometer");
        char ok = dbus_connection_send_with_reply_and_block(
                      connection, msg, DBUS_TIMEOUT_INFINITE, &error) != NULL;
        dbus_message_unref(msg);
        if (ok) {
            return connection;
        }
    }
    return NULL;
}

enum Orientation property_to_enum(const char* orientation) {
    if (!strcmp(orientation, "normal")) {
        return Normal;
    }
    if (!strcmp(orientation, "bottom-up")) {
        return BottomUp;
    }
    if (!strcmp(orientation, "left-up")) {
        return LeftUp;
    }
    if (!strcmp(orientation, "right-up")) {
        return RightUp;
    }

    return Undefined;
}

enum Orientation parse_orientation_signal(DBusMessage* msg) {
    DBusMessageIter args, iter_array, iter_dict, iter_v;
    const char *iface, *property, *orientation;
    if (dbus_message_iter_init(msg, &args)) {
        dbus_message_iter_get_basic(&args, &iface);
        if (!strcmp("net.hadess.SensorProxy", iface)) {
            dbus_message_iter_next(&args);
            dbus_message_iter_recurse(&args, &iter_array);
            dbus_message_iter_recurse(&iter_array, &iter_dict);
            dbus_message_iter_get_basic(&iter_dict, &property);
            if (!strcmp(property, "AccelerometerOrientation")) {
                dbus_message_iter_next(&iter_dict);
                dbus_message_iter_recurse(&iter_dict, &iter_v);
                dbus_message_iter_get_basic(&iter_v, &orientation);
                return property_to_enum(orientation);
            }
        }
    }
    return Undefined;
}

void system_fmt(char* format, ...) {
    char command[128];
    va_list args;
    va_start(args, format);
    vsnprintf(command, sizeof(command), format, args);
    system(command);
    va_end(args);
}

void handle_orientation(enum Orientation orientation) {
    switch (orientation) {
        case Normal:
            system_fmt("hyprctl keyword monitor %s,transform,0", output);
            system_fmt("hyprctl keyword device:%s:transform 0", touch_yoga);
            system_fmt("hyprctl keyword device:%s:transform 0", pen_yoga);
            break;

        case BottomUp:
            system_fmt("hyprctl keyword monitor %s,transform,2", output);
            system_fmt("hyprctl keyword device:%s:transform 2", touch_yoga);
            system_fmt("hyprctl keyword device:%s:transform 2", pen_yoga);
            break;

        case LeftUp:
            system_fmt("hyprctl keyword monitor %s,transform,1", output);
            system_fmt("hyprctl keyword device:%s:transform 1", touch_yoga);
            system_fmt("hyprctl keyword device:%s:transform 1", pen_yoga);
            break;

        case RightUp:
            system_fmt("hyprctl keyword monitor %s,transform,3", output);
            system_fmt("hyprctl keyword device:%s:transform 3", touch_yoga);
            system_fmt("hyprctl keyword device:%s:transform 3", pen_yoga);
            break;

        default:
            break;
    }
}

DBusMessage* request_orientation(DBusConnection* conn) {

    // create request calling Get method
    DBusMessage* req = dbus_message_new_method_call(
        "net.hadess.SensorProxy", // destination
        "/net/hadess/SensorProxy", // path
        "org.freedesktop.DBus.Properties", // iface
        "Get" // method
    );

    // append arguments of Get method to request
    const char* interface_name = "net.hadess.SensorProxy";
    const char* property_name = "AccelerometerOrientation";
    dbus_message_append_args(req,
        DBUS_TYPE_STRING, &interface_name,
        DBUS_TYPE_STRING, &property_name,
        DBUS_TYPE_INVALID
    );

    // send request and get reply
    DBusMessage* reply = dbus_connection_send_with_reply_and_block(
        conn,
        req,
        DBUS_TIMEOUT_INFINITE,
        &error
    );

    // check reply
    if (dbus_error_is_set(&error)) {
        printf("Error receiving orientation request: %s: %s\n",
               error.name, error.message);
    }

    // clean up and return
    dbus_message_unref(req);
    return reply;
}

enum Orientation parse_orientation_reply(DBusMessage* reply) {
    DBusMessageIter iter, sub_iter;
    const char* orientation;
    dbus_message_iter_init(reply, &iter);
    dbus_message_iter_recurse(&iter, &sub_iter); // DBUS_TYPE_VARIANT
    dbus_message_iter_get_basic(&sub_iter, &orientation); // DBUS_TYPE_STRING
    return property_to_enum(orientation);
}

void init_orientation(DBusConnection* conn) {
// this function proactively requests current orientation, even if not changed
    DBusMessage* reply = request_orientation(conn);
    if (reply != NULL) {
        handle_orientation(parse_orientation_reply(reply));
        dbus_message_unref(reply);
    }
}

void listen_orientation(DBusConnection* connection) {
// this function passively listens for changes to orientation
    DBusMessage* msg;
    dbus_bus_add_match(connection,
        "type='signal',interface='org.freedesktop.DBus.Properties'", &error);
    dbus_bus_add_match(connection,
        "type='signal',sender='org.freedesktop.DBus',interface='org."
        "freedesktop.DBus',member='NameOwnerChanged',arg0='net.hadess."
        "SensorProxy'",
        &error);
    dbus_connection_flush(connection);
    while (dbus_connection_read_write_dispatch(connection, -1)) {
        msg = dbus_connection_pop_message(connection);
        if (msg != NULL) {
            if (dbus_message_is_signal(msg, "org.freedesktop.DBus.Properties",
                    "PropertiesChanged")) {
                handle_orientation(parse_orientation_signal(msg));
            } else {
                dbus_message_unref(msg);
                break;
            }
            dbus_message_unref(msg);
        }
    }
}

int main(int argc, char* argv[]) {
    DBusConnection* connection = dbus_connect();
    if (connection == NULL) {
        printf("error: cannot open dbus connection\n");
        return 1;
    }
    if (argc > 1) {
        output = argv[1];
    }

    // if hyprland and iio-hyprland are restarted after display is already rotated,
    // init_orientation ensures correct immediate orientation without
    // waiting for display to move
    init_orientation(connection);

    listen_orientation(connection);

    dbus_disconnect(connection);
    return 0;
}

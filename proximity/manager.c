/*
 *
 *  BlueZ - Bluetooth protocol stack for Linux
 *
 *  Copyright (C) 2011  Nokia Corporation
 *  Copyright (C) 2011  Marcel Holtmann <marcel@holtmann.org>
 *
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <glib.h>
#include <gdbus.h>

#include "adapter.h"
#include "device.h"
#include "monitor.h"
#include "reporter.h"
#include "manager.h"

#define IMMEDIATE_ALERT_UUID	"00001802-0000-1000-8000-00805f9b34fb"
#define LINK_LOSS_UUID		"00001803-0000-1000-8000-00805f9b34fb"
#define TX_POWER_UUID		"00001804-0000-1000-8000-00805f9b34fb"

static DBusConnection *connection = NULL;

static int attio_device_probe(struct btd_device *device, GSList *uuids)
{
	return monitor_register(connection, device);
}

static void attio_device_remove(struct btd_device *device)
{
	monitor_unregister(connection, device);
}

static struct btd_device_driver monitor_driver = {
	.name = "Proximity GATT Driver",
	.uuids = BTD_UUIDS(IMMEDIATE_ALERT_UUID, LINK_LOSS_UUID, TX_POWER_UUID),
	.probe = attio_device_probe,
	.remove = attio_device_remove,
};

int proximity_manager_init(DBusConnection *conn)
{
	int ret;
	/* TODO: Add Proximity Monitor/Reporter config */

	/* TODO: Register Proximity Monitor/Reporter drivers */
	ret = btd_register_device_driver(&monitor_driver);
	if (ret < 0)
		return ret;

	connection = dbus_connection_ref(conn);

	return reporter_init();
}

void proximity_manager_exit(void)
{
	reporter_exit();
	btd_unregister_device_driver(&monitor_driver);
	dbus_connection_unref(connection);
}

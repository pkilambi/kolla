#!/bin/sh

. /opt/kolla/kolla-common.sh
. /opt/kolla/config-ceilometer.sh

check_required_vars KEYSTONE_AUTH_PROTOCOL CEILOMETER_KEYSTONE_USER CEILOMETER_ADMIN_PASSWORD ADMIN_TENANT_NAME

check_for_keystone
check_for_db

export SERVICE_TOKEN="${KEYSTONE_ADMIN_TOKEN}"
export SERVICE_ENDPOINT="${KEYSTONE_AUTH_PROTOCOL}://${KEYSTONEMASTER_35357_PORT_35357_TCP_ADDR}:35357/v2.0"

exec /usr/bin/ceilometer-agent-central

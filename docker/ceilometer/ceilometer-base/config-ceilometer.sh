#!/bin/sh

set -e
. /opt/kolla/kolla-common.sh

: ${CEILOMETER_DB_USER:=ceilometer}
: ${CEILOMETER_DB_NAME:=ceilometer}
: ${KEYSTONE_AUTH_PROTOCOL:=http}
: ${CEILOMETER_KEYSTONE_USER:=admin}
: ${CEILOMETER_ADMIN_PASSWORD:=kolla}
: ${ADMIN_TENANT_NAME:=admin}
: ${METERING_SECRET:=ceilometer}

check_required_vars CEILOMETER_DB_PASSWORD KEYSTONE_ADMIN_TOKEN DB_ROOT_PASSWORD
dump_vars

cat > /openrc <<EOF
export SERVICE_TOKEN="${KEYSTONE_ADMIN_TOKEN}"
export SERVICE_ENDPOINT="${KEYSTONE_AUTH_PROTOCOL}://${KEYSTONEMASTER_35357_PORT_35357_TCP_ADDR}:35357/v2.0"
EOF


cfg=/etc/ceilometer/ceilometer.conf

crudini --set $cfg
    DEFAULT rpc_backend rabbit
crudini --set $cfg
    DEFAULT rabbit_host ${KEYSTONE_SERVICE_HOST}
crudini --set $cfg
    DEFAULT rabbit_password ${RABBITMQ_PASS}

crudini --set $cfg \
    keystone_authtoken \
    auth_uri \
    "http://${KEYSTONE_SERVICE_HOST}:5000/"
crudini --set $cfg \
    keystone_authtoken \
    admin_tenant_name \
    "${ADMIN_TENANT_NAME}"
crudini --set $cfg \
    keystone_authtoken \
    admin_user \
    "${CEILOMETER_KEYSTONE_USER}"
crudini --set $cfg \
    keystone_authtoken \
    admin_password \
    ${CEILOMETER_ADMIN_PASSWORD}

crudini --set $cfg \
    service_credentials \
    os_auth_url \
    ${KEYSTONE_AUTH_PROTOCOL}://${KEYSTONE_SERVICE_HOST}:5000/
crudini --set $cfg \
    service_credentials \
    os_username \
    ceilometer
crudini --set $cfg \
    service_credentials \
    os_tenant_name \
    service
crudini --set $cfg \
    service_credentials \
    os_password \
    ${CEILOMETER_ADMIN_PASSWORD}

crudini --set $cfg \
    publisher
    metering_secret
    ${METERING_SECRET}

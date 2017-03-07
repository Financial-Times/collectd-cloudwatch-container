#!/usr/bin/env bash
/collective/cloudwatch-alarms/put_metric_alarm.py --namespace ${NAMESPACE} --instanceid ${INSTANCEID} --topic ${TOPIC}
/usr/sbin/collectd -f

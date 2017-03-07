#!/usr/bin/env bash
#
# A wrapper script that creates CloudWatch Alarms and starts collectd daemon

if [[ -z "${TOPIC}" ]]; then #If TOPIC is not set generate invalid SNS Topic name 'environment_variable_topic_unset' that flags warning in alarm settings
  REGION=$(curl -s --connect-timeout 3 http://169.254.169.254/latest/meta-data/placement/availability-zone/)
  if [[ ! -z ${REGION} ]]; then
    REGION=${REGION:0:-1}
  else
    REGION="eu-west-1"
  fi
  TOPIC="arn:aws:sns:${REGION}:account:environment_variable_topic_unset"
fi
/collective/cloudwatch-alarms/put_metric_alarm.py --namespace ${NAMESPACE} --instanceid ${INSTANCEID} --topic ${TOPIC}
/usr/sbin/collectd -f

#!/usr/bin/env bash
#
# A wrapper script that creates CloudWatch Alarms and starts collectd daemon

# Attempt to resolve region if AWS_DEFAULT_REGION is unset. Fall back to eu-west-1.
if [[ -z "${AWS_DEFAULT_REGION}"]]; then
  REGION=$(curl -s --connect-timeout 3 http://169.254.169.254/latest/meta-data/placement/availability-zone/)
  if [[ ! -z ${REGION} ]]; then
    export AWS_DEFAULT_REGION=${REGION:0:-1}
  else
    export AWS_DEFAULT_REGION="eu-west-1"
  fi
fi

# If TOPIC is unset generate invalid SNS Topic name 'environment_variable_topic_unset' that flags warning in alarm settings
if [[ -z "${TOPIC}" ]]; then
  TOPIC="arn:aws:sns:${AWS_DEFAULT_REGION}:account:environment_variable_topic_unset"
fi

# Create alarms
/collective/cloudwatch-alarms/put_metric_alarm.py --namespace ${NAMESPACE} --instanceid ${INSTANCEID} --topic ${TOPIC}

# Start colletd daemon
/usr/sbin/collectd -f

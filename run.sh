#!/usr/bin/env bash
#
# A wrapper script that creates CloudWatch Alarms and starts collectd daemon

declare -a OPTIONAL_ARGS

# Attempt to resolve region if AWS_DEFAULT_REGION is unset. Fall back to eu-west-1.
if [[ -z ${AWS_DEFAULT_REGION} ]]; then
  REGION=$(curl -s --connect-timeout 3 http://169.254.169.254/latest/meta-data/placement/availability-zone/)
  if [[ ! -z ${REGION} ]]; then
    export AWS_DEFAULT_REGION=${REGION:0:-1}
  else
    export AWS_DEFAULT_REGION="eu-west-1"
  fi
fi

# If TOPIC is set append it to OPTIONAL_ARGS array
if [[ ! -z "${TOPIC}" ]]; then
  OPTIONAL_ARGS+="--topic ${TOPIC}"
  OPTIONAL_ARGS+=" " # Append whitespace separator incase more more args are appended
fi
# If CONFIG is set append it to OPTIONAL_ARGS array
if [[ ! -z "${CONFIG}" ]]; then
  OPTIONAL_ARGS+="--config ${CONFIG}"
  OPTIONAL_ARGS+=" "
fi

# Create alarms
/collective/cloudwatch-alarms/put_metric_alarm.py --namespace ${NAMESPACE} --instanceid ${INSTANCEID} ${OPTIONAL_ARGS}

# Start colletd daemon
/usr/sbin/collectd -f

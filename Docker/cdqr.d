#!/bin/bash
cdqr_version="5.0.0"
cur_dir="$(pwd)"
docker_network=${DOCKER_NETWORK}
timesketch_conf=${TIMESKETCH_CONF:-"/opt/Skadi/Docker/timesketch/timesketch_default.conf"}
timesketch_conf_legacy="/etc/timesketch.conf"
timesketch_server_ipaddress=${TIMESKETCH_SERVER_IPADDRESS:-""}
docker_args="docker run -d "
args=()

fix_path () {
  file_path=$1
  file_path="$(echo $file_path | sed 's/ /\\ /g')"
  eval file_path=$file_path
  if [ "${file_path:0:1}" == "/" ]; then
    #this is a root level path, do not modify
    final_path=$file_path
  elif [ "${file_path:0:2}" == "./" ]; then
    #this is a current dir path, modify to add absolute path
    final_path=("$cur_dir/${file_path:2:${#file_path}}")
  elif [ "${file_path:0:1}" == "~" ]; then
    #this is a home dir path, modify to add absolute path
    final_path=("$(echo $HOME)/${file_path:2:${#file_path}}")
  else
    final_path=("$cur_dir/$file_path")
  fi
  echo "$final_path"
}

# Set the docker network (if any) to use
if [ $docker_network ]; then
  echo "Validating the Docker network exists: $docker_network"
  if [ $(docker network ls |grep $docker_network |awk '{print $2}' ) ]; then
    echo "Connecting CDQR to the Docker network: $docker_network"
    docker_args="$docker_args --network $docker_network "
  else
    echo "Docker network $docker_network does not exist, quitting"
    exit
  fi
else
  echo "Assigning CDQR to the host network"
  echo "The Docker network can be changed by modifying the \"DOCKER_NETWORK\" environment variable"
  echo "Example (default Skadi mode): export DOCKER_NETWORK=host"
  echo "Example (use other Docker network): export DOCKER_NETWORK=skadi-backend"
  docker_args="$docker_args --network host "
fi

for i in "$@"; do
  # If it's timesketch add the timesketch mapping
  if [ "$i" == "--es_ts" ]; then
    if [ ! -f "$timesketch_conf" ]; then
      if [ -f "$timesketch_conf_legacy" ]; then
        timesketch_conf=$timesketch_conf_legacy
      else
        echo "TimeSketch default configuration file must be set with Environment variable in daemon mode."
        echo "The default configuration is the absolute path to Skadi/Docker/timesketch/timesketch_default.conf."
        echo "Example with Skadi git repo in \"/opt/Skadi\"): export TIMESKETCH_CONF=\"/opt/Skadi/Docker/timesketch/timesketch_default.conf\""
        echo "Exiting"
        exit
      fi
    fi
    if [ "$timesketch_server_ipaddress" == "" ]; then
        timesketch_server_ipaddress='127.0.0.1'
    fi
    docker_args="$docker_args --add-host=elasticsearch:$timesketch_server_ipaddress --add-host=postgres:$timesketch_server_ipaddress -v ${timesketch_conf}:/etc/timesketch.conf"
  fi

  # If it's an input file/dir (denoted by "in:" then resolve absolute path)
  if [ "${i:0:3}" == "in:" ]; then
    input_map="${i:3:${#i}}"
    final_input_path="$(fix_path '$input_map')"
    args+=($final_input_path)
    docker_args="$docker_args -v $final_input_path:$final_input_path"
  # If it's an output file/dir (denoted by "out:" then resolve absolute path)
  elif [ "${i:0:4}" == "out:" ]; then
    output_map="${i:4:${#i}}"
    final_output_path="$(fix_path '$output_map')"
    args+=($final_output_path)
    docker_args="$docker_args -v $final_output_path:$final_output_path"
  # Everything is is copied over as is
  else
    args+=("$i")
  fi
done

final_command="$docker_args aorlikoski/cdqr:$cdqr_version -y ${args[@]}"
echo "$final_command"
$final_command

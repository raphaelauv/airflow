#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

#######################################################################################################
#
# Adds trap to the traps already set.
#
# Arguments:
#      trap to set
#      .... list of signals to handle
#######################################################################################################
function traps::add_trap() {
    trap="${1}"
    shift
    for signal in "${@}"
    do
        # adding trap to exiting trap
        local handlers
        # shellcheck disable=SC2046
        handlers="$(_parse_current_traps "${signal}")"
        # shellcheck disable=SC2064
        trap "${trap};${handlers}" "${signal}"
    done
}

function _parse_current_traps() {
  local signal="$1"
  # Yes, eval is evil, but this is the only way I was able to "parse" the output of trap which is "already" quoted
  eval "set -- $(trap -p "$signal")"
  # Output format is `trap -- 'command' <signal>`
  echo "${3-}"
}

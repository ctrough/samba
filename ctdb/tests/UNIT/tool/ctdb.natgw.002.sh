#!/bin/sh

. "${TEST_SCRIPTS_DIR}/unit.sh"

define_test "3 nodes, all in natgw group, 1 unhealthy"

setup_natgw <<EOF
192.168.20.41
192.168.20.42
192.168.20.43
EOF

setup_ctdbd <<EOF
NODEMAP
0       192.168.20.41   0x2
1       192.168.20.42   0x0     CURRENT RECMASTER
2       192.168.20.43   0x0
EOF

#####

required_result 0 <<EOF
1 192.168.20.42
EOF

simple_test leader

#####

required_result 0 <<EOF
192.168.20.41
192.168.20.42	LEADER
192.168.20.43
EOF

simple_test list

#####

required_result 0 <<EOF
pnn:0 192.168.20.41    UNHEALTHY
pnn:1 192.168.20.42    OK (THIS NODE)
pnn:2 192.168.20.43    OK
EOF

simple_test status

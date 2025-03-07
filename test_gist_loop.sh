#!/bin/bash

BUILD_DIR="build"
DATATYPE="float"
A_BUILD=1.75
QUERY_FILE="data/gist/gist_query.fbin"
GT_FILE="data/gist/gist_query_learn_gt100"
DATA_PATH="data/gist/gist_learn.fbin"
B_BUILD=0.025
M_BUILD=40.0
K_SEARCH=10
RESULT_PATH="data/gist/res"

# List of R_BUILD values to iterate over
R_BUILD_values=" 74 72 70 68 52"

# List of L_BUILD values corresponding to each R_BUILD value
declare -A L_BUILD_values=( ["74"]="74" ["72"]="72" ["70"]="70" ["68"]="118" ["52"]="104")

for R_BUILD in $R_BUILD_values; do
    L_BUILD=${L_BUILD_values[$R_BUILD]}

    INDEX_PATH_PREFIX="data/gist/disk_index_gist_learn_R${R_BUILD}_L${L_BUILD}_A${A_BUILD}"


  # Generate the ground truth
    ${BUILD_DIR}/apps/utils/compute_groundtruth --data_type ${DATATYPE} --dist_fn l2 --base_file ${DATA_PATH} --query_file ${QUERY_FILE} --gt_file ${GT_FILE} --K 100
    rm -rf ${INDEX_PATH_PREFIX}*
    # Build the index
    ${BUILD_DIR}/apps/build_disk_index --data_type ${DATATYPE} --dist_fn l2 --data_path ${DATA_PATH} --index_path_prefix ${INDEX_PATH_PREFIX} -R ${R_BUILD} -L ${L_BUILD} -B ${B_BUILD} -M ${M_BUILD} -A ${A_BUILD}

    # Search
    L_SEARCH="2000 2300 2600 2900 3200 3500 3800 4100 4400 4700 5000 5300 5600 5900 6200 6600 7000 7500 8000 8600"
    ${BUILD_DIR}/apps/search_disk_index --data_type ${DATATYPE} --dist_fn l2 --index_path_prefix ${INDEX_PATH_PREFIX} --query_file ${QUERY_FILE} --gt_file ${GT_FILE} -K ${K_SEARCH} -L ${L_SEARCH} --result_path ${RESULT_PATH} --num_nodes_to_cache 10000
done

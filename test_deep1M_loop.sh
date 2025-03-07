#!/bin/bash

BUILD_DIR="build"
DATATYPE="float"
A_BUILD=2.0
QUERY_FILE="data/deep1M/deep1M_query.fbin"
GT_FILE="data/deep1M/deep1M_query_learn_gt100"
DATA_PATH="data/deep1M/deep1M_learn.fbin"
B_BUILD=0.025
M_BUILD=40.0
K_SEARCH=10
RESULT_PATH="data/deep1M/res"

# List of R_BUILD values to iterate over
R_BUILD_values="76 70"

# List of L_BUILD values corresponding to each R_BUILD value
declare -A L_BUILD_values=( ["76"]="125" ["70"]="125" )

for R_BUILD in $R_BUILD_values; do
    L_BUILD=${L_BUILD_values[$R_BUILD]}
   
    INDEX_PATH_PREFIX="data/deep1M/disk_index_deep1M_learn_R${R_BUILD}_L${L_BUILD}_A${A_BUILD}"
    
    # Generate the ground truth
    ${BUILD_DIR}/apps/utils/compute_groundtruth --data_type ${DATATYPE} --dist_fn l2 --base_file ${DATA_PATH} --query_file ${QUERY_FILE} --gt_file ${GT_FILE} --K 100
    rm -rf ${INDEX_PATH_PREFIX}*
    # Build the index
    ${BUILD_DIR}/apps/build_disk_index --data_type ${DATATYPE} --dist_fn l2 --data_path ${DATA_PATH} --index_path_prefix ${INDEX_PATH_PREFIX} -R ${R_BUILD} -L ${L_BUILD} -B ${B_BUILD} -M ${M_BUILD} -A ${A_BUILD}
    
    # Search
    L_SEARCH="10 20 30 40 50 80 100 150 200 250 300 400 500"
    ${BUILD_DIR}/apps/search_disk_index --data_type ${DATATYPE} --dist_fn l2 --index_path_prefix ${INDEX_PATH_PREFIX} --query_file ${QUERY_FILE} --gt_file ${GT_FILE} -K ${K_SEARCH} -L ${L_SEARCH} --result_path ${RESULT_PATH} --num_nodes_to_cache 10000
done

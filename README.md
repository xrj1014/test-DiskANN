# Project Name: DiskANN Implementation for Approximate Nearest Neighbor Search

This repository contains the code for our paper, which builds upon the existing [DiskANN](https://github.com/microsoft/DiskANN) library from Microsoft. The code is designed to perform approximate nearest neighbor (ANN) search on large-scale datasets, with experiments conducted on three datasets: SIFT1M, GIST1M, and Deep1M.

## Overview

The main code in this repository is adapted from [DiskANN](https://github.com/microsoft/DiskANN), a highly efficient library for ANN search on disk-based indices. We extend its functionality to test performance on the SIFT1M, GIST1M, and Deep1M datasets, with scripts for building indices, generating ground truth, and evaluating search performance.

## Dependencies

- **DiskANN**: The core library used for building and searching disk-based indices. Refer to the original [DiskANN repository](https://github.com/microsoft/DiskANN) for installation instructions.
- **Python**: Required for running `graph_build.py` (ensure you have `numpy` and `matplotlib` installed).
- **Bash**: Used to execute the provided shell scripts (`*.sh` files).
- **C++ Compiler**: Required to build the DiskANN binaries (e.g., `g++`).

To install Python dependencies:
```bash
pip install numpy matplotlib
```

Follow the DiskANN documentation to compile the source code and create the `build` directory with the necessary binaries (`apps/build_disk_index`, `apps/search_disk_index`, and `apps/utils/compute_groundtruth`).

## Datasets

The experiments in this repository are conducted on the following datasets:
1. **SIFT1M**: 1 million 128-dimensional SIFT vectors.
   - Download: [http://corpus-texmex.irisa.fr/](http://corpus-texmex.irisa.fr/)
2. **GIST1M**: 1 million 960-dimensional GIST descriptors.
   - Download: [http://corpus-texmex.irisa.fr/](http://corpus-texmex.irisa.fr/)
3. **Deep1M**: 1 million 256-dimensional deep learning features.
   - Download: [https://www.cse.cuhk.edu.hk/systems/hash/gqr/datasets.html](https://www.cse.cuhk.edu.hk/systems/hash/gqr/datasets.html)

The datasets are stored in the `data/` directory with subdirectories for each dataset (`data/sift1M/`, `data/gist1M/`, `data/deep1M/`). Preprocessed test results for these datasets are also included in the `data/` directory.

## Code Structure

- **`graph_build.py`**: A Python script to generate visualizations of the index-building process. It uses the dataset `vec_sift1m.npy` as an example input.
- **`test_deep1M_loop.sh`**: A Bash script to build and search the Deep1M dataset with varying parameters.
- **`test_sift_loop.sh`**: A Bash script for the SIFT1M dataset (assumed similar structure to `test_deep1M_loop.sh`).
- **`test_gist_loop.sh`**: A Bash script for the GIST1M dataset (assumed similar structure to `test_deep1M_loop.sh`).
- **`data/`**: Directory containing datasets and test results.
- **`build/`**: Directory containing compiled DiskANN binaries (must be generated by building the DiskANN library).

### Example Script: `test_deep1M_loop.sh`
The script iterates over different `R_BUILD` values (e.g., 76, 70) and corresponding `L_BUILD` values (e.g., 125) to:
1. Compute ground truth for the Deep1M dataset.
2. Build a disk-based index.
3. Perform ANN search with varying `L_SEARCH` values (10 to 500).

Key parameters:
- `DATATYPE="float"`: Data type of the vectors.
- `A_BUILD=2.0`: Alpha parameter for index building.
- `B_BUILD=0.025`: Beta parameter for index building.
- `M_BUILD=40.0`: Memory budget parameter.
- `K_SEARCH=10`: Number of nearest neighbors to retrieve during search.

## Usage Instructions

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd <repository-name>
```

### 2. Set Up DiskANN
Clone and build the DiskANN library as per its [instructions](https://github.com/microsoft/DiskANN#building-the-code). Ensure the `build/` directory contains the necessary binaries.

### 3. Download Datasets
Download the datasets from the provided links and place them in the `data/` directory with the following structure:
```
data/
├── sift1M/
│   ├── vec_sift1m.npy
│   └── ...
├── gist1M/
│   └── ...
├── deep1M/
│   ├── deep1M_learn.fbin
│   ├── deep1M_query.fbin
│   ├── deep1M_query_learn_gt100
│   └── res/
```

### 4. Run the Scripts
Execute the shell scripts to build indices and perform searches:
```bash
bash test_deep1M_loop.sh
bash test_sift_loop.sh
bash test_gist_loop.sh
```

### 5. Visualize Results
Run `graph_build.py` to generate diagrams (modify the script if you want to use a different dataset):
```bash
python graph_build.py
```


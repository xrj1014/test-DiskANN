import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import math

# Set dataset size and dimensions
size = 1000000
dim = 128

# Generate a uniformly distributed dataset
dataset = np.load('vec_sift1m.npy')
print("DATASET_SHAPE:", dataset.shape)

i = np.random.randint(0, dataset.shape[0])
query = dataset[i,:]
# Use the origin as the query point

print("USE_MEAN_AS_THE_TEST_POINT")

# Calculate the Euclidean distance between embedding vectors
dist = np.linalg.norm(dataset - query, axis=1)

edges = []
t = 0
left = np.sum(dist == float('inf'))

while left < size:
        
        # print( t+1, "-TH")
        
        min_point = dist.argmin()
        edges.append((query, dataset[min_point,:]))
        dist[min_point] = float('inf')

        # Get the embedding of the nearest point
        min_point_embedding = dataset[min_point,:]

        # Calculate the Euclidean distance of each vector to the nearest point
        dd = np.linalg.norm(dataset - min_point_embedding, axis=1)
        # Exclude points in dist that are already inf, set corresponding values in dd to inf
        dd[dist == float('inf')] = float('inf')
        
        # Exclude points where dd < dist, set corresponding values in dist to inf
        # print("EXCLUDED_POINTS:", np.sum(dd<dist))
        dist[dd<dist] = float('inf')

        t += 1
        left = np.sum(dist == float('inf'))
        # print("left:", left)

# Output the nearest neighbor pairs
# print("Nearest neighbor pairs:", edges)
print("NUMBER_OF_NN:", len(edges))

# Project embeddings data into two-dimensional space
plt.rcParams['axes.facecolor'] = 'lavender'
x = dataset[:, 0]
y = dataset[:, 1]

# Draw a scatter plot
plt.figure(figsize=(8, 8))
sns.scatterplot(x=x, y=y)

# Draw connecting lines
for edge in edges:
    query_point, min_point = edge
    plt.plot([query_point[0], min_point[0]], [query_point[1], min_point[1]], 'r-', linewidth=1)

plt.title('Projection of Embeddings with Nearest Neighbors')
plt.xlabel('The first component of the SIFT1M vectors')
plt.ylabel('The second component of the SIFT1M vectors')
plt.savefig('result.png')
plt.show()
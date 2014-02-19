# data.rb: Data sets for use in Statbench RSpec tests

# We will have to do something about this down the line but for
# now, it makes the tests run...
RELATIVE_PATH = "./data_files/"

DATA_FILE_1 = RELATIVE_PATH + 'data1.txt'
DATA_FILE_2 = RELATIVE_PATH + 'data2.txt'
DATA_FILE_3 = RELATIVE_PATH + 'data3.txt'
DATA_FILE_4 = RELATIVE_PATH + 'data4.txt'
DATA_FILE_5 = RELATIVE_PATH + 'data5.txt'
DATA_FILE_6 = RELATIVE_PATH + 'data6.txt'

# DATASET_1: n = 200, x_bar = 28.6536, s = 16.7105
DATASET_1 = [ 33.25, 26.61, 51.67, 25.89, 49.64, 2.96, 13.33, 20.61, 38.98, 
      32.06, 2.46, 16.54, 44.1, 11.94, 44.43, 50.1, 20.24, 47.26, 
      9.57, 48.8, 18.71, 50.65, 25.63, 38.42, 8.45, 18.38, 55.97, 
      48.22, 49.09, 32.52, 57.8, 28.35, 52.61, 17.49, 0.8, 36.74, 
      50.54, 52.91, 5.24, 7.89, 56.54, 1.57, 50.9, 42.2, 33.54, 
      44.95, 19.15, 8.72, 21.68, 58.02, 9.98, 10.02, 24.6, 42.61, 
      2.41, 19.49, 13.03, 6.26, 52.88, 23.0, 55.62, 18.0, 12.84, 
      13.43, 32.38, 18.77, 46.27, 7.69, 4.93, 8.03, 37.12, 10.67, 
      34.84, 45.41, 19.05, 41.65, 47.74, 0.87, 25.84, 30.61, 38.29, 
      30.33, 41.87, 36.33, 15.58, 13.05, 14.42, 22.38, 17.51, 32.81, 
      18.48, 27.23, 27.91, 53.51, 42.99, 40.18, 41.99, 29.49, 34.06, 
      14.01, 32.84, 1.43, 54.42, 56.36, 21.78, 10.19, 24.95, 0.64, 
      15.91, 49.14, 47.06, 30.47, 35.12, 18.67, 49.82, 36.42, 26.0, 
      57.82, 35.54, 3.42, 31.01, 57.26, 18.92, 24.57, 35.33, 53.04, 
      12.0, 46.56, 32.15, 31.98, 52.48, 41.43, 7.73, 17.77, 44.06, 
      1.37, 46.18, 17.45, 5.54, 11.48, 16.63, 42.48, 46.14, 55.55, 
      58.71, 56.18, 31.6, 19.52, 3.11, 16.53, 12.77, 29.68, 38.57, 
      2.52, 33.47, 30.45, 23.74, 44.21, 18.75, 7.39, 14.76, 37.52, 
      23.92, 33.8, 54.13, 30.46, 19.2, 49.18, 16.91, 56.38, 24.6, 
      13.89, 15.56, 47.88, 1.98, 49.28, 36.36, 34.5, 3.14, 33.54, 
      13.19, 28.48, 29.22, 0.42, 29.77, 4.37, 10.68, 19.75, 30.85, 
      12.21, 20.16, 52.97, 37.47, 38.33, 32.4, 0.34, 23.68, 9.28, 
      51.07, 12.21 ]

# DATASET_2: n = 200, x_bar = 29.2633, s = 17.7392
DATASET_2 = [ 51.55, 23.27, 42.02, 21.72, 57.72, 2.97, 53.6, 56.66, 35.99, 
      50.24, 53.59, 20.93, 12.92, 35.55, 48.53, 55.06, 39.08, 8.43, 
      22.11, 48.95, 51.08, 17.34, 55.92, 16.81, 41.28, 36.79, 37.26, 
      7.92, 57.27, 55.2, 17.64, 44.41, 5.56, 36.99, 37.92, 23.06, 
      17.56, 50.2, 32.21, 37.68, 22.4, 40.46, 45.88, 8.28, 10.18, 
      40.74, 22.33, 12.98, 5.24, 21.21, 43.76, 20.63, 3.47, 36.2, 
      4.48, 24.85, 3.47, 29.13, 29.47, 35.93, 25.78, 13.51, 50.41, 
      32.86, 35.79, 58.09, 40.24, 54.95, 22.85, 5.0, 17.52, 3.89, 
      2.13, 0.94, 33.52, 36.07, 50.33, 5.07, 50.87, 51.1, 9.35, 
      28.45, 41.11, 43.34, 10.23, 53.77, 22.24, 53.75, 47.13, 16.87, 
      21.4, 22.57, 22.5, 18.65, 52.13, 11.22, 27.59, 39.99, 51.7, 
      47.43, 2.77, 57.8, 24.06, 34.2, 21.31, 40.56, 53.27, 45.0, 
      34.94, 2.28, 25.98, 4.11, 45.89, 32.99, 50.2, 56.54, 48.95, 
      44.74, 4.78, 13.3, 14.58, 30.78, 3.05, 37.96, 16.76, 16.68, 
      55.2, 14.18, 0.01, 5.65, 0.18, 21.2, 6.68, 41.65, 40.76, 
      43.56, 51.32, 57.67, 51.28, 10.19, 4.31, 5.85, 11.1, 17.18, 
      12.81, 13.96, 20.33, 38.31, 13.41, 12.12, 5.7, 13.69, 14.22, 
      57.56, 37.5, 23.67, 2.98, 54.67, 11.77, 1.52, 52.32, 39.33, 
      54.88, 20.69, 39.05, 56.35, 33.7, 1.41, 45.99, 41.36, 45.87, 
      20.2, 33.51, 9.66, 47.97, 35.9, 9.44, 18.38, 2.17, 19.73, 2.68, 
      59.98, 29.56, 25.57, 36.1, 34.02, 14.74, 20.92, 15.79, 15.64, 
      34.44, 50.84, 32.45, 32.95, 3.01, 17.79, 44.82, 3.65, 44.48, 55.23 ]

# DATASET_3: n = 217, x_bar = 17.2154, s = 9.5504
DATASET_3 = [ 21.85, 30.92, 17.67, 21.22, 33.55, 10.51, 8.05, 3.49, 20.23, 1.65, 
      12.74, 33.4, 6.48, 14.64, 13.04, 25.54, 23.27, 17.88, 17.52, 24.28, 
      1.6, 31.61, 20.48, 18.84, 5.86, 6.77, 6.13, 34.82, 33.02, 26.89, 
      21.15, 18.15, 10.0, 15.03, 19.37, 31.93, 25.35, 9.36, 1.76, 19.34, 
      17.37, 1.14, 4.23, 2.84, 28.59, 12.01, 15.82, 6.53, 10.07, 12.26, 
      9.26, 23.75, 2.63, 18.03, 33.5, 16.85, 1.24, 23.12, 6.38, 4.12, 24.0, 
      10.45, 24.73, 9.61, 18.1, 24.28, 17.96, 4.34, 24.8, 11.63, 15.27, 6.47, 
      28.07, 21.98, 10.65, 15.86, 13.2, 20.57, 16.07, 31.64, 22.97, 32.29, 
      26.86, 29.57, 30.33, 16.24, 34.23, 23.97, 3.51, 30.1, 9.05, 25.69, 7.54, 
      24.05, 33.91, 2.38, 21.59, 4.64, 22.14, 29.99, 16.45, 5.26, 9.76, 3.58, 
      16.67, 31.38, 14.96, 17.58, 6.37, 19.29, 9.07, 19.32, 31.95, 27.14, 
      18.21, 20.0, 1.36, 3.99, 9.63, 1.6, 20.41, 15.45, 2.8, 27.63, 18.08, 
      24.18, 2.55, 15.02, 14.4, 13.83, 11.46, 14.44, 34.93, 32.02, 13.02, 23.09, 
      1.56, 33.93, 5.68, 15.14, 9.98, 19.55, 5.78, 23.31, 8.71, 23.49, 15.18, 
      9.89, 1.25, 16.3, 26.14, 27.25, 19.22, 19.06, 6.28, 26.86, 18.77, 11.22, 
      23.2, 32.4, 23.71, 34.35, 9.43, 21.1, 34.53, 11.61, 28.62, 23.33, 21.2, 
      20.58, 9.55, 10.35, 30.48, 28.67, 6.95, 23.29, 15.07, 15.26, 10.91, 32.58, 
      15.32, 32.96, 2.71, 28.54, 4.53, 5.53, 2.97, 13.95, 10.04, 17.83, 5.95, 
      27.04, 19.54, 14.33, 19.92, 26.92, 23.67, 7.89, 28.95, 13.2, 11.41, 15.25, 
      32.34, 11.45, 9.94, 13.21, 32.1, 1.61, 21.17, 6.4, 16.02, 10.22, 5.49, 
      18.19, 33.18, 24.31, 27.21 ]

# DATASET_4: n = 211, x_bar = 23.63123, s = 13.1332
DATASET_4 = [ 9.79, 18.73, 9.36, 11.68, 3.64, 5.0, 13.29, 19.36, 5.13, 20.11, 
              9.75, 24.68, 20.28, 8.87, 15.45, 10.43, 21.97, 7.08, 2.21, 22.35, 22.85, 
              28.76, 17.45, 29.53, 9.15, 9.91, 1.56, 0.46, 12.57, 25.56, 7.48, 1.11, 24.1, 
              8.98, 9.28, 17.64, 26.32, 14.45, 0.94, 27.51, 26.92, 20.54, 22.86, 23.7, 
              23.12, 22.96, 7.5, 20.97, 26.54, 6.13, 22.67, 21.02, 24.33, 22.2, 22.58, 
              27.93, 0.88, 17.41, 26.63, 16.57, 23.4, 12.86, 3.2, 18.67, 5.37, 15.25, 20.88,
              26.24, 8.63, 25.96, 29.75, 9.13, 17.84, 24.84, 14.76, 7.61, 12.98, 8.66, 
              23.56, 3.67, 27.3, 16.15, 28.18, 24.87, 5.32, 21.37, 6.26, 7.58, 10.21, 16.47, 
              12.81, 0.61, 2.92, 28.32, 19.53, 3.7, 14.04, 3.04, 9.49, 15.94, 27.58, 21.31, 
              25.55, 38.42, 19.92, 46.11, 14.8, 49.1, 45.78, 11.45, 40.09, 16.66, 35.47, 
              44.36, 34.78, 13.09, 10.91, 29.0, 14.21, 15.41, 36.52, 20.48, 25.22, 28.86, 
              44.37, 28.05, 22.44, 32.12, 25.87, 43.77, 34.35, 14.08, 34.34, 38.09, 49.86, 
              15.74, 34.15, 36.31, 41.48, 40.7, 48.99, 34.83, 38.97, 47.31, 27.68, 14.71, 
              34.62, 11.37, 20.71, 33.35, 34.57, 40.92, 44.48, 17.13, 44.33, 48.57, 33.25, 
              29.51, 36.76, 15.77, 29.73, 12.2, 20.91, 36.83, 11.19, 48.48, 20.76, 17.68, 
              41.02, 36.97, 31.5, 16.54, 49.69, 32.75, 13.28, 22.85, 37.93, 26.2, 43.12, 
              41.7, 46.18, 22.39, 37.09, 37.43, 36.99, 46.51, 26.52, 45.8, 11.49, 42.62, 
              36.48, 47.54, 11.68, 13.39, 21.81, 25.01, 18.97, 29.79, 29.36, 49.8, 40.72, 
              14.31, 28.77, 14.87, 49.44, 11.38, 49.79, 34.11, 42.71, 19.58, 48.1 ]

# DATASET_5: n = 200, x_bar = 20.7051, s = 11.9600
DATASET_5 = [ 0.84, 0.16, 13.12, 34.68, 3.24, 38.81, 15.12, 22.91, 31.51, 7.15, 
              25.96, 39.9, 33.9, 6.97, 23.87, 13.83, 4.54, 13.78, 28.84, 39.34, 
              24.36, 16.07, 4.7, 32.76, 12.41, 12.84, 25.47, 0.45, 23.38, 31.34, 
              32.74, 36.22, 27.17, 23.62, 29.63, 6.53, 10.67, 12.82, 2.62, 39.16, 
              6.3, 14.77, 21.99, 15.94, 35.76, 16.36, 33.82, 17.36, 23.44, 30.35, 
              10.27, 24.53, 32.64, 29.69, 21.87, 29.5, 8.87, 25.16, 10.74, 33.95, 
              15.6, 25.8, 25.29, 9.79, 8.3, 5.67, 30.07, 32.03, 38.09, 24.72, 
              36.46, 5.3, 25.69, 11.46, 6.38, 22.38, 37.37, 4.25, 21.01, 21.16, 
              27.06, 14.24, 28.31, 5.99, 7.65, 18.49, 7.3, 29.4, 12.18, 24.53, 
              0.73, 5.66, 26.48, 15.48, 3.34, 39.4, 36.35, 37.42, 3.03, 32.21, 
              34.9, 10.03, 4.38, 12.02, 30.0, 1.32, 16.16, 35.47, 30.71, 1.14, 
              30.0, 7.37, 7.65, 36.41, 23.11, 2.8, 31.05, 33.2, 37.88, 19.68, 
              32.29, 27.78, 27.69, 22.07, 6.21, 38.46, 10.69, 22.13, 34.71, 
              35.71, 37.61, 5.92, 13.38, 39.66, 9.46, 33.96, 23.9, 10.43, 31.35, 
              27.06, 18.74, 16.49, 1.63, 8.97, 9.18, 38.57, 34.67, 37.13, 9.74, 
              38.97, 4.13, 23.05, 23.76, 4.39, 20.43, 38.44, 7.83, 16.28, 8.3, 
              11.9, 36.46, 15.87, 20.06, 13.54, 5.6, 28.94, 1.39, 5.27, 16.32, 
              1.5, 28.92, 26.17, 32.15, 24.35, 16.46, 36.99, 6.47, 24.65, 39.81, 
              8.56, 28.8, 7.24, 29.66, 34.03, 39.95, 22.9, 17.96, 1.43, 11.25, 
              37.45, 38.29, 27.51, 18.0, 22.65, 6.14, 39.39, 17.56, 11.39, 
              25.53, 17.25 ]

# DATASET_6: n = 200, x_bar = 30.19, s = 17.4386
DATASET_6 = [ 59.0, 56.0, 53.0, 48.0, 13.0, 54.0, 4.0, 33.0, 30.0, 33.0, 32.0, 
              36.0, 58.0, 28.0, 15.0, 3.0, 52.0, 46.0, 22.0, 12.0, 30.0, 3.0, 
              13.0, 30.0, 26.0, 20.0, 49.0, 34.0, 28.0, 38.0, 7.0, 38.0, 36.0, 
              23.0, 56.0, 25.0, 2.0, 46.0, 15.0, 46.0, 10.0, 55.0, 3.0, 56.0, 
              53.0, 28.0, 19.0, 17.0, 51.0, 25.0, 23.0, 37.0, 15.0, 24.0, 57.0, 
              54.0, 28.0, 20.0, 11.0, 30.0, 21.0, 13.0, 49.0, 10.0, 5.0, 57.0, 
              2.0, 55.0, 19.0, 50.0, 48.0, 49.0, 6.0, 52.0, 22.0, 23.0, 17.0, 
              52.0, 32.0, 57.0, 9.0, 5.0, 57.0, 17.0, 50.0, 12.0, 27.0, 52.0, 
              34.0, 1.0, 33.0, 54.0, 25.0, 7.0, 39.0, 45.0, 30.0, 37.0, 4.0, 
              8.0, 33.0, 54.0, 22.0, 53.0, 12.0, 16.0, 42.0, 38.0, 5.0, 38.0, 
              3.0, 52.0, 5.0, 57.0, 53.0, 17.0, 8.0, 14.0, 43.0, 37.0, 50.0, 
              56.0, 38.0, 24.0, 19.0, 6.0, 31.0, 16.0, 25.0, 13.0, 16.0, 27.0, 
              3.0, 13.0, 6.0, 24.0, 26.0, 4.0, 27.0, 32.0, 5.0, 15.0, 20.0, 50.0, 
              27.0, 39.0, 9.0, 43.0, 10.0, 33.0, 46.0, 35.0, 6.0, 32.0, 34.0, 
              40.0, 58.0, 3.0, 59.0, 35.0, 43.0, 25.0, 56.0, 60.0, 34.0, 39.0, 
              7.0, 37.0, 21.0, 54.0, 5.0, 59.0, 49.0, 18.0, 12.0, 8.0, 3.0, 
              11.0, 9.0, 30.0, 46.0, 38.0, 29.0, 12.0, 24.0, 35.0, 44.0, 42.0, 
              51.0, 43.0, 28.0, 29.0, 51.0, 31.0, 57.0, 40.0, 33.0, 56.0, 15.0, 
              44.0]
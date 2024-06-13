# Convolutional Neural Network

From ChatGPT.

A Convolutional Neural Network (CNN) is a type of deep learning model specifically designed for processing structured grid-like data, such as images. CNNs are particularly effective for tasks involving visual perception, such as image classification, object detection, and image segmentation.

CNNs are inspired by the structure and functioning of the visual cortex in animals, where neurons in different layers respond to different features of the visual stimuli. Similarly, CNNs consist of multiple layers of interconnected neurons that learn hierarchical representations of features present in the input data.

Here's an overview of the key components and operations in a typical CNN architecture:

1. **Convolutional Layers**:
    - Convolutional layers are the core building blocks of CNNs. They apply a set of learnable filters (also called kernels or convolutional kernels) to the input data to extract features.
    - Each filter performs a convolution operation, which involves sliding the filter over the input data and computing dot products between the filter weights and the local regions of the input.
    - The output of each filter is a feature map that represents the presence of a particular feature or pattern in the input data.
    - Multiple filters are typically used in each convolutional layer to capture different types of features.

2. **Activation Functions**:
    - After the convolution operation, an activation function (such as ReLU, sigmoid, or tanh) is applied element-wise to the feature maps to introduce non-linearity into the network.
    - The non-linear activation helps the network learn complex patterns and relationships in the input data.

3. **Pooling Layers**:
    - Pooling layers are used to downsample the feature maps and reduce their spatial dimensions while retaining the most important information.
    - Common pooling operations include max pooling and average pooling, which take the maximum or average value, respectively, within each pooling region.
    - Pooling helps make the representations more invariant to small spatial translations and reduces the computational complexity of the network.

4. **Fully Connected Layers**:
    - After several convolutional and pooling layers, the feature maps are flattened into a one-dimensional vector and passed through one or more fully connected (dense) layers.
    - Fully connected layers perform a linear transformation followed by a non-linear activation function to generate the final output of the network.
    - They enable the network to learn complex mappings from the extracted features to the output classes or predictions.

5. **Training**:
    - CNNs are trained using gradient-based optimisation algorithms, such as stochastic gradient descent (SGD) or Adam, to minimise a loss function that measures the difference between the predicted outputs and the ground truth labels.
    - The weights of the filters and fully connected layers are updated iteratively using backpropagation, which calculates gradients of the loss function with respect to the network parameters and adjusts the parameters accordingly.

Overall, CNNs are powerful and versatile models for visual perception tasks, capable of automatically learning hierarchical representations of features from raw input data. They have demonstrated state-of-the-art performance in various computer vision tasks and are widely used in both academic research and industry applications.

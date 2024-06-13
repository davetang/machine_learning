# Autoencoders

From ChatGPT.

Autoencoder models are a class of neural networks used for unsupervised learning tasks, particularly for dimensionality reduction, feature learning, and data compression. The primary objective of an autoencoder is to learn a compact representation of the input data by encoding it into a lower-dimensional space and then reconstructing the original data from this representation as accurately as possible.

The basic structure of an autoencoder consists of two main components:

1. **Encoder**: The encoder network maps the input data into a lower-dimensional latent space representation. It typically consists of one or more layers of neurons that gradually reduce the dimensionality of the input data.

2. **Decoder**: The decoder network reconstructs the original input data from the latent space representation produced by the encoder. It mirrors the structure of the encoder but in reverse, gradually expanding the dimensionality of the latent representation back to the original input space.

During training, autoencoders are optimised to minimise the reconstruction error, which measures the difference between the input data and its reconstruction. By learning to reconstruct the input data accurately, autoencoders implicitly learn meaningful features and representations of the data.

There are several families or variants of autoencoder models, each with its own characteristics and use cases. Some of the main families of autoencoders include:

1. **Vanilla Autoencoders**: Also known as undercomplete autoencoders, vanilla autoencoders have a bottleneck structure in the latent space, forcing the model to learn a compressed representation of the input data.

2. **Denoising Autoencoders**: Denoising autoencoders are trained to reconstruct clean input data from noisy or corrupted input samples. They learn to denoise the input data by capturing the underlying structure and removing noise.

3. **Sparse Autoencoders**: Sparse autoencoders introduce sparsity constraints on the activations of the hidden layers. They encourage the model to learn sparse representations of the input data, which can help disentangle and extract meaningful features.

4. **Variational Autoencoders (VAEs)**: VAEs are probabilistic autoencoder models that learn a probabilistic model of the input data and use variational inference techniques to approximate the latent space distribution. They enable the generation of new data samples by sampling from the learned latent space distribution.

5. **Contractive Autoencoders**: Contractive autoencoders incorporate penalty terms in the loss function to enforce smoothness and local linearity in the learned latent space. They are robust to small variations in the input data and can learn invariant representations.

6. **Generative Adversarial Networks (GANs)**: Although not traditional autoencoders, GANs consist of a generator network that learns to generate realistic data samples from random noise and a discriminator network that learns to distinguish between real and generated samples. GANs can be considered as implicitly learning a compressed representation of the input data through the generator network.

Each family of autoencoder models has its own advantages and is suitable for different types of data and tasks. Choosing the appropriate autoencoder variant depends on the specific requirements of the problem at hand, such as the nature of the input data, the desired properties of the learned representations, and the intended application of the model.

## Variational Autoencoder

A Variational Autoencoder (VAE) is a type of generative model that learns to generate new data samples by capturing the underlying structure and distribution of the input data. VAEs belong to the family of autoencoder models, which are neural networks trained to learn efficient representations of input data by compressing it into a lower-dimensional latent space and then reconstructing the original data from this representation.

The key innovation of VAEs compared to traditional autoencoders is the introduction of probabilistic modeling and variational inference techniques. VAEs learn a probabilistic model of the data and use variational inference to approximate the posterior distribution of the latent variables given the observed data. This allows VAEs to generate new data samples by sampling from the learned latent space distribution.

Here's how a Variational Autoencoder works:

1. **Encoder Network**:
    - The encoder network takes an input data sample and maps it to a distribution in the latent space. Instead of directly outputting the values of the latent variables, the encoder network outputs the parameters (mean and variance) of a Gaussian distribution that represents the approximate posterior distribution of the latent variables given the input data.

2. **Sampling Latent Variables**:
    - During training, a sample is drawn from the approximate posterior distribution (using the reparameterisation trick) to obtain a latent representation for the input data sample.
    - This sampled latent vector serves as a compressed representation of the input data in the latent space.

3. **Decoder Network**:
    - The decoder network takes the sampled latent vector as input and reconstructs the original data sample from it.
    - The decoder network is trained to produce a reconstruction that closely matches the input data sample.

4. **Training Objective**:
    - VAEs are trained to minimise a loss function that consists of two components: a reconstruction loss and a regularisation term.
    - The reconstruction loss measures the discrepancy between the input data sample and its reconstruction.
    - The regularisation term, often expressed as the Kullback-Leibler (KL) divergence between the approximate posterior distribution and a prior distribution (typically a standard Gaussian), encourages the learned latent space to be structured and interpretable.

5. **Generating New Data**:
    - After training, VAEs can generate new data samples by sampling from the learned latent space distribution.
    - By sampling from the latent space and feeding the samples through the decoder network, VAEs can generate new data samples that resemble the training data.

Variational Autoencoders have applications in various domains, including image generation, text generation, and molecular design. They can learn meaningful latent representations of complex data distributions and generate diverse and realistic new samples from these distributions.

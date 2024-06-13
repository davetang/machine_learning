# TabNet

Notes from [TabNet: Attentive Interpretable Tabular Learning](https://arxiv.org/abs/1908.07442).

## Abstract

* We propose a novel high-performance and **interpretable** canonical deep tabular data learning architecture, TabNet.
* TabNet uses **sequential attention** to choose which features to reason from at each decision step, enabling interpretability and more efficient learning as the learning capacity is used for the most salient features.
* We demonstrate that TabNet outperforms other neural network and decision tree variants on a wide range of non-performance-saturated tabular datasets and yields interpretable feature attributions plus insights into the global model behavior.
* Finally, for the first time to our knowledge, we demonstrate **self-supervised learning for tabular data**, significantly improving performance with unsupervised representation learning when unlabeled data is abundant.

## ChatGPT summary

TabNet is a deep learning model designed specifically for tabular data, which consists of structured data organised into rows and columns, commonly found in databases and spreadsheets. TabNet combines ideas from both neural networks and decision trees to achieve state-of-the-art performance on tabular data while maintaining interpretability. The key features of TabNet include:

1. **TabNet Architecture**:
    - TabNet is a neural network architecture based on the transformer architecture, which is known for its success in natural language processing tasks.
    - It consists of a series of repeated encoder-decoder blocks, where each block performs feature transformation and attention-based feature selection.
    - The encoder blocks extract features from the input data, while the decoder blocks reconstruct the original features from the selected features.

2. **Attention Mechanism**:
    - TabNet utilises an attention mechanism to select informative features at each step of the training process.
    - At each layer of the network, a sparse attention mask is computed based on the feature importance scores obtained from the previous layer.
    - This attention mask is used to select a subset of features that are most relevant for prediction, allowing the model to focus on the most informative features while ignoring irrelevant ones.

3. **Sparse Feature Selection**:
    - Unlike traditional neural networks that use all input features for prediction, TabNet employs sparse feature selection to enhance interpretability and efficiency.
    - By selecting only a subset of features at each layer based on their importance scores, TabNet reduces the computational overhead and improves the model's ability to learn from high-dimensional tabular data.

4. **Decision-Tree-Like Properties**:
    - TabNet exhibits decision-tree-like properties, where each layer of the network selects a subset of features to make predictions.
    - This hierarchical feature selection process resembles the decision-making process of decision trees, making TabNet more interpretable and easier to understand compared to traditional neural networks.

5. **Interpretability**:
    - TabNet provides interpretability by allowing users to analyse the importance scores assigned to each input feature.
    - These importance scores indicate the contribution of each feature to the model's predictions, helping users understand which features are most influential in making decisions.

Notes from [TabNet: Attentive Interpretable Tabular
Learning](https://arxiv.org/abs/1908.07442).

## Abstract

-   We propose a novel high-performance and **interpretable** canonical
    deep tabular data learning architecture, TabNet.
-   TabNet uses **sequential attention** to choose which features to
    reason from at each decision step, enabling interpretability and
    more efficient learning as the learning capacity is used for the
    most salient features.
-   We demonstrate that TabNet outperforms other neural network and
    decision tree variants on a wide range of non-performance-saturated
    tabular datasets and yields interpretable feature attributions plus
    insights into the global model behavior.
-   Finally, for the first time to our knowledge, we demonstrate
    **self-supervised learning for tabular data**, significantly
    improving performance with unsupervised representation learning when
    unlabeled data is abundant.

## ChatGPT summary

TabNet is a deep learning model designed specifically for tabular data,
which consists of structured data organised into rows and columns,
commonly found in databases and spreadsheets. TabNet combines ideas from
both neural networks and decision trees to achieve state-of-the-art
performance on tabular data while maintaining interpretability. The key
features of TabNet include:

1.  **TabNet Architecture**:
    -   TabNet is a neural network architecture based on the transformer
        architecture, which is known for its success in natural language
        processing tasks.
    -   It consists of a series of repeated encoder-decoder blocks,
        where each block performs feature transformation and
        attention-based feature selection.
    -   The encoder blocks extract features from the input data, while
        the decoder blocks reconstruct the original features from the
        selected features.
2.  **Attention Mechanism**:
    -   TabNet utilises an attention mechanism to select informative
        features at each step of the training process.
    -   At each layer of the network, a sparse attention mask is
        computed based on the feature importance scores obtained from
        the previous layer.
    -   This attention mask is used to select a subset of features that
        are most relevant for prediction, allowing the model to focus on
        the most informative features while ignoring irrelevant ones.
3.  **Sparse Feature Selection**:
    -   Unlike traditional neural networks that use all input features
        for prediction, TabNet employs sparse feature selection to
        enhance interpretability and efficiency.
    -   By selecting only a subset of features at each layer based on
        their importance scores, TabNet reduces the computational
        overhead and improves the model's ability to learn from
        high-dimensional tabular data.
4.  **Decision-Tree-Like Properties**:
    -   TabNet exhibits decision-tree-like properties, where each layer
        of the network selects a subset of features to make predictions.
    -   This hierarchical feature selection process resembles the
        decision-making process of decision trees, making TabNet more
        interpretable and easier to understand compared to traditional
        neural networks.
5.  **Interpretability**:
    -   TabNet provides interpretability by allowing users to analyse
        the importance scores assigned to each input feature.
    -   These importance scores indicate the contribution of each
        feature to the model's predictions, helping users understand
        which features are most influential in making decisions.

## Session info

Time built.

    ## [1] "2024-06-20 23:19:50 UTC"

Session info.

    ## R version 4.4.0 (2024-04-24)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 22.04.4 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so;  LAPACK version 3.10.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## time zone: Etc/UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] lubridate_1.9.3 forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4    
    ##  [5] purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
    ##  [9] ggplot2_3.5.1   tidyverse_2.0.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] gtable_0.3.5      compiler_4.4.0    tidyselect_1.2.1  scales_1.3.0     
    ##  [5] yaml_2.3.8        fastmap_1.1.1     R6_2.5.1          generics_0.1.3   
    ##  [9] knitr_1.46        munsell_0.5.1     pillar_1.9.0      tzdb_0.4.0       
    ## [13] rlang_1.1.3       utf8_1.2.4        stringi_1.8.3     xfun_0.43        
    ## [17] timechange_0.3.0  cli_3.6.2         withr_3.0.0       magrittr_2.0.3   
    ## [21] digest_0.6.35     grid_4.4.0        hms_1.1.3         lifecycle_1.0.4  
    ## [25] vctrs_0.6.5       evaluate_0.23     glue_1.7.0        fansi_1.0.6      
    ## [29] colorspace_2.1-0  rmarkdown_2.27    tools_4.4.0       pkgconfig_2.0.3  
    ## [33] htmltools_0.5.8.1

# Extending-DiT-Beyond-ImageNet1K

## Fine-Tuning a Diffusion Transformer on a Custom ImageNet Subset Under Limited Compute Constraints

## Overview

Diffusion models have recently become one of the dominant approaches for high-quality image generation, with Diffusion Transformers (DiTs) demonstrating strong performance by replacing traditional U-Net backbones with transformer architectures.

This project investigates whether a pretrained Diffusion Transformer can be successfully fine-tuned on image categories outside the original ImageNet-1K training distribution. The work focuses not only on model training, but also on understanding the underlying DiT architecture, constructing a specialized dataset, modifying an existing large-scale training pipeline, and evaluating model behavior under significant computational and storage constraints.

The project was completed as part of a Computer Vision seminar course at Smith College.

---

## Research Question

Can a pretrained Diffusion Transformer be fine-tuned to generate image categories outside the classes on which it was originally trained?

---

## Project Goals

- Curate a specialized ImageNet-based dataset with minimal semantic overlap with ImageNet-1K
- Explore transfer learning behavior in Diffusion Transformers
- Evaluate model performance on unseen data categories.

---

## Dataset Construction

The dataset was constructed from ImageNet-21K categories.

The curation process involved:
- Aggregating metadata from multiple ImageNet repositories
- Filtering hierarchical parent categories
- Removing ImageNet-1K overlap
- Manually selecting visually and semantically distinct classes
- Downloading and preprocessing category tar files
- Creating train/validation/test splits

The final dataset contained:
- **102 custom image categories**
- Categories with **600+ images each**
- Minimal intended overlap with ImageNet-1K classes

---

## Training Setup

Training was performed using:
- **Model:** DiT-XL/2
- **Framework:** Fast-DiT
- **GPU:** Google Colab A100
- **Batch Size:** 256
- **Training Duration:** 50 epochs (~21K training steps)
- **Runtime:** ~13 hours

To accelerate training, the model was trained on pre-extracted VAE latent representations rather than raw images.

---

## Major Pipeline Modifications

The original Fast-DiT codebase assumed large-scale distributed multi-GPU training on ImageNet-1K. Significant modifications were required for this project.

Key modifications included:
- Shape-mismatch-aware pretrained weight loading
- Expansion of class embeddings from 1000 → 1102 classes
- Label-offset logic to preserve pretrained ImageNet-1K embeddings
- Single-GPU adaptation for Colab environments
- Resume-from-checkpoint functionality
- Logger fixes for Colab compatibility
- Infrastructure optimizations for Google Drive I/O limitations

---

## Results

The model demonstrated stable training behavior throughout fine-tuning, with losses gradually decreasing over training.

Qualitative sampling across checkpoints showed:
- Early checkpoints produced mostly noisy outputs
- Later checkpoints generated increasingly recognizable object structure
- Best results were obtained using 250 diffusion sampling steps
- The model appeared to partially adapt to the new dataset distribution

FID evaluation was planned but not completed due to compute and runtime limitations.

---

## Repository Contents

This repository contains:
- Dataset preprocessing and curation scripts
- Training notebook
- Sampling notebook
- Loss curve plots
- Qualitative sampling outputs
- Log output from training

---

## References

### DiT Paper
Peebles, W., & Xie, S.  
*Scalable Diffusion Models with Transformers*  
ICCV 2023

### Fast-DiT Repository
https://github.com/chuanyangjin/fast-DiT

### ImageNet
Deng, J. et al.  
*ImageNet: A Large-Scale Hierarchical Image Database*  
CVPR 2009

---

## Acknowledgements

I would like to thank Prof. Howe for his guidance and feedback throughout this project. His support was invaluable in helping me navigate both the technical and research challenges involved in working with diffusion models and large-scale training pipelines.

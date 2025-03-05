# Tomato Leaf Disease Classifier with CLIP Pre-check

## Overview
This project implements an intelligent system for classifying tomato leaf diseases using deep learning, with an innovative **CLIP-based pre-check system** to ensure only leaf images are processed. The system includes both a FastAPI backend and a React frontend, providing a user-friendly interface for disease detection.

## Key Features
- **CLIP Pre-check System**: Utilizes OpenAI's CLIP model to verify if uploaded images are actually leaves before processing.
- **Disease Classification**: Identifies 10 different tomato leaf conditions.
- **User-friendly Interface**: Clean, responsive React frontend with real-time feedback.
- **Efficient Processing**: Optimized image processing pipeline with JAX backend.

## Technical Architecture

### Backend (FastAPI + JAX)
- FastAPI for REST API implementation.
- JAX backend for efficient model inference.
- CLIP model for image validation.
- Hugging Face model hosting and loading.
- Comprehensive error handling and validation.

### Frontend (React)
- Material-UI components for clean interface.
- Real-time image preview.
- Progress indicators.
- Error handling and user feedback.
- Responsive design.

## Model Training

### Dataset
- Source: [Kaggle Plant Village Dataset](https://www.kaggle.com/datasets/arjuntejaswi/plant-village).
- **Important Note**: Due to computational constraints on Kaggle/Colab, only 50% of the dataset was used for training.
- This reduction in training data affected the model's learning rate and potentially its overall accuracy.

### Training Process
1. Trained on Kaggle's GPU environment.
2. Used transfer learning with a pre-trained backbone.
3. Implemented data augmentation to compensate for reduced dataset.
4. Model achieved reasonable accuracy despite data limitations.

### Model Hosting
- Model is hosted on Hugging Face Hub: [AlphaMintamir/Tomato_Leaf_Classifier](https://huggingface.co/AlphaMintamir/Tomato_Leaf_Classifier).
- Enables easy model loading and version control.
- Facilitates deployment and sharing.

## Innovative CLIP Pre-check
One of the most notable features is the implementation of CLIP (Contrastive Language-Image Pre-training) for image validation:

- **Purpose**: Ensures only leaf images are processed by the classification model.
- **How it works**: 
  1. Uses CLIP to compare uploaded images against leaf-related text descriptions.
  2. Provides a confidence score for "leafness".
  3. Only proceeds to disease classification if image passes the leaf check.
- **Benefits**:
  - Reduces incorrect classifications.
  - Improves user experience.
  - Saves computational resources.

## Usage
1. Access the web interface at `http://localhost:3000`.
2. Upload an image of a tomato leaf.
3. The system will:
   - First verify if the image is a leaf using CLIP.
   - Then classify the disease if verification passes.
4. View results with confidence scores.

## Limitations and Future Improvements
- Currently using only 50% of the original dataset due to computational constraints.
- Model accuracy could be improved with full dataset training.
- Potential for more sophisticated CLIP prompts for better leaf detection.
- Opportunity for multi-crop disease detection.

## Dependencies
- Backend: FastAPI, JAX, CLIP, Hugging Face Transformers.
- Frontend: React, Material-UI, Axios.
- See `requirements.txt` for complete Python dependencies.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Installation and Setup

### Backend Setup

Create and activate virtual environment:
```sh
python -m venv venv
source venv/bin/activate # On Linux/Mac
.\venv\Scripts\activate # On Windows
```
Install dependencies:
```sh
pip install -r requirements.txt
```
Run the backend:
```sh
cd api
python main.py
```

### Frontend Setup

Install dependencies:
```sh
cd frontend
npm install
```
Run the frontend:
```sh
npm start
```

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
import os
os.environ["KERAS_BACKEND"] = "jax"
import keras
import torch
from transformers import CLIPProcessor, CLIPModel
from huggingface_hub import hf_hub_download


app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:3000",  # React development server
    "http://127.0.0.1:3000",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load model from Hugging Face Hub
model_path = hf_hub_download(
    repo_id="AlphaMintamir/Tomato_Leaf_Classifier",
    filename="tomato_35epoch.keras"
)
MODEL = keras.saving.load_model(model_path)

CLASS_NAMES = ['Tomato_Bacterial_spot',
 'Tomato_Early_blight',
 'Tomato_Late_blight',
 'Tomato_Leaf_Mold',
 'Tomato_Septoria_leaf_spot',
 'Tomato_Spider_mites_Two_spotted_spider_mite',
 'Tomato__Target_Spot',
 'Tomato__Tomato_YellowLeaf__Curl_Virus',
 'Tomato__Tomato_mosaic_virus',
 'Tomato_healthy']

# Load CLIP model and processor
CLIP_MODEL = CLIPModel.from_pretrained("openai/clip-vit-base-patch32")
CLIP_PROCESSOR = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch32")

def read_file_as_image(data) -> np.ndarray:
    image = Image.open(BytesIO(data)).convert('RGB')  
    image = image.resize((256, 256))  
    image = np.array(image) / 255.0  
    return image

async def check_if_leaf(image: Image.Image) -> bool:
    # Prepare text descriptions
    text_descriptions = [
        "a photo of a leaf",
        "a photo of a plant leaf",
        "a photo of a tomato leaf",
        "a photo of a tomato plant",
        "a close up photo of a leaf"
    ]
    
    # Prepare the image and text inputs
    inputs = CLIP_PROCESSOR(
        images=image,
        text=text_descriptions,
        return_tensors="pt",
        padding=True
    )
    
    # Get prediction
    with torch.no_grad():
        outputs = CLIP_MODEL(**inputs)
        logits_per_image = outputs.logits_per_image
        probs = logits_per_image.softmax(dim=1)
    
    # If any probability is above threshold, consider it a leaf
    max_prob = probs.max().item()
    return max_prob > 0.25  # You can adjust this threshold

@app.get("/ping")
async def ping():
    return "Hello, I am alive"

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        # Read and validate file content
        contents = await file.read()
        if not contents:
            raise HTTPException(status_code=400, detail="Empty file")
            
        # Open image for CLIP check
        pil_image = Image.open(BytesIO(contents)).convert('RGB')
        
        # Check if image is a leaf using CLIP
        is_leaf = await check_if_leaf(pil_image)
        
        if not is_leaf:
            raise HTTPException(
                status_code=400,
                detail="The uploaded image does not appear to be a leaf or plant. Please upload a clear image of a tomato leaf."
            )
        
        # Process image for disease classification
        image = read_file_as_image(contents)
        img_batch = np.expand_dims(image, 0)
        
        # Make prediction
        predictions = MODEL.predict(img_batch)
        predicted_class = CLASS_NAMES[np.argmax(predictions[0])]
        confidence = float(np.max(predictions[0]))
        
        return {
            "class": predicted_class,
            "confidence": confidence
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host='localhost', port=8000)
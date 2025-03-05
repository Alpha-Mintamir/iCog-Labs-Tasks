import React, { useState } from 'react';
import { 
  Container, 
  Paper, 
  Typography, 
  Box, 
  Button,
  CircularProgress,
  Alert
} from '@mui/material';
import CloudUploadIcon from '@mui/icons-material/CloudUpload';
import axios from 'axios';
import './App.css';

function App() {
  const [selectedFile, setSelectedFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [prediction, setPrediction] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleFileSelect = (event) => {
    const file = event.target.files[0];
    if (file) {
      setSelectedFile(file);
      setPreview(URL.createObjectURL(file));
      setPrediction(null);
      setError(null);
    }
  };

  const handleSubmit = async () => {
    if (!selectedFile) return;

    const formData = new FormData();
    formData.append('file', selectedFile);

    setLoading(true);
    setError(null);
    
    try {
      const response = await axios.post('http://localhost:8000/predict', formData);
      setPrediction(response.data);
    } catch (err) {
      setError(err.response?.data?.detail || 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h4" align="center" gutterBottom>
          Tomato Leaf Disease Classifier
        </Typography>
        
        <Box sx={{ my: 4, textAlign: 'center' }}>
          <input
            type="file"
            accept="image/*"
            onChange={handleFileSelect}
            style={{ display: 'none' }}
            id="upload-button"
          />
          <label htmlFor="upload-button">
            <Button
              variant="contained"
              component="span"
              startIcon={<CloudUploadIcon />}
            >
              Upload Image
            </Button>
          </label>
        </Box>

        {preview && (
          <Box sx={{ my: 4, textAlign: 'center' }}>
            <img 
              src={preview} 
              alt="Preview" 
              style={{ maxWidth: '100%', maxHeight: '300px' }} 
            />
            <Box sx={{ mt: 2 }}>
              <Button 
                variant="contained" 
                onClick={handleSubmit}
                disabled={loading}
              >
                {loading ? <CircularProgress size={24} /> : 'Analyze'}
              </Button>
            </Box>
          </Box>
        )}

        {error && (
          <Alert severity="error" sx={{ mt: 2 }}>
            {error}
          </Alert>
        )}

        {prediction && (
          <Box sx={{ mt: 4, textAlign: 'center' }}>
            <Typography variant="h6" gutterBottom>
              Prediction Result
            </Typography>
            <Typography variant="body1">
              Disease: {prediction.class.replace(/_/g, ' ')}
            </Typography>
            <Typography variant="body1">
              Confidence: {(prediction.confidence * 100).toFixed(2)}%
            </Typography>
          </Box>
        )}
      </Paper>
    </Container>
  );
}

export default App; 
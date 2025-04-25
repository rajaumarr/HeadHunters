from fastapi import FastAPI, UploadFile, Form, HTTPException
import spacy
from spacy import displacy
import numpy as np
from PyPDF2 import PdfReader
from docx import Document
import os

app = FastAPI()

trained_resume = spacy.load("d:/FYP/Final/VERCEL-FASTAPI/api/assets/model_cv/model-best")
trained_job = spacy.load("d:/FYP/Final/VERCEL-FASTAPI/api/assets/model_cv/model-last")

# Extract text from PDF
def extract_text_from_pdf(file):
    try:
        pdf_reader = PdfReader(file)
        text = ""
        for page in pdf_reader.pages:
            extracted = page.extract_text()
            if extracted:
                text += extracted
        if not text.strip():
            raise ValueError("No text extracted from PDF")
        return text
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"PDF extraction failed: {str(e)}")

# Extract text from DOCX
def extract_text_from_docx(file):
    try:
        document = Document(file)
        return '\n'.join([para.text for para in document.paragraphs if para.text.strip()])
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"DOCX extraction failed: {str(e)}")

# Extract text from TXT
def extract_text_from_txt(file):
    try:
        return file.read().decode('utf-8')
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"TXT extraction failed: {str(e)}")

# Get unique entities
def get_unique_entities(doc):
    return list({ent.text.lower() for ent in doc.ents})

# Compute cosine similarity
def compute_entity_similarity(job_ents, resume_ents, nlp):
    if not job_ents or not resume_ents:
        return 0.0, [], []
    job_ent_vecs = [nlp(ent).vector for ent in job_ents]
    resume_ent_vecs = [nlp(ent).vector for ent in resume_ents]
    job_avg_vec = np.mean(job_ent_vecs, axis=0)
    resume_avg_vec = np.mean(resume_ent_vecs, axis=0)
    if np.linalg.norm(job_avg_vec) == 0 or np.linalg.norm(resume_avg_vec) == 0:
        return 0.0, job_ents, resume_ents
    cos_sim_score = np.dot(resume_avg_vec, job_avg_vec) / (
        np.linalg.norm(resume_avg_vec) * np.linalg.norm(job_avg_vec)
    )
    return float(cos_sim_score), job_ents, resume_ents

@app.post("/")
async def calculate_similarity(resume: UploadFile, job_description: str = Form(...)):
    ext = os.path.splitext(resume.filename)[-1].lower()
    if ext == ".pdf":
        resume_text = extract_text_from_pdf(resume.file)
    elif ext == ".docx":
        resume_text = extract_text_from_docx(resume.file)
    elif ext == ".txt":
        resume_text = extract_text_from_txt(resume.file)
    else:
        raise HTTPException(status_code=400, detail="Unsupported file type. Only .pdf, .docx, and .txt are allowed.")

    resume_doc = trained_resume(resume_text)
    job_doc = trained_job(job_description)

    job_entities = get_unique_entities(job_doc)
    resume_entities = get_unique_entities(resume_doc)

    similarity_score, unique_job_ents, unique_resume_ents = compute_entity_similarity(
        job_entities, resume_entities, trained_resume
    )

    print("Job Entities:", unique_job_ents)
    print("Resume Entities:", unique_resume_ents)
    print("Similarity:", similarity_score)

    return {
        "similarity_score": similarity_score * 100
    }

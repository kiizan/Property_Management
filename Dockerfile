# Use Python 3.11 slim as the base image
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the entire project to the container
COPY . /app

# Set environment variable for Python path
ENV PYTHONPATH=/app

# Run the data insertion script by default
CMD ["python", "app/insert_data.py"]

FROM python:3.10-slim

# Install Flask safely using pip (no threading or caching)
RUN pip install --no-cache-dir --progress-bar off flask

# Copy project files into container
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/

# Expose Flask port
EXPOSE 5050

# Run the app
CMD ["python3", "/home/myapp/sample_app.py"]

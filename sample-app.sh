#!/bin/bash
# ======================================================
# Flask Sample App Docker Builder (Safe Version using pip)
# ======================================================

# Clean up any old temp directories or containers/images
rm -rf tempdir
docker rm -f samplerunning 2>/dev/null
docker rmi sampleapp 2>/dev/null

# Recreate project structure
mkdir -p tempdir/templates tempdir/static

# Copy application files
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Build Dockerfile from scratch
cat <<'EOF' > tempdir/Dockerfile
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
EOF

# Build and run the container
cd tempdir
echo "🔧 Building Docker image (using up to 4GB memory)..."
docker build --memory=4g --no-cache -t sampleapp .

echo "🚀 Running container on port 5050..."
docker run -t -d -p 5050:5050 --name samplerunning sampleapp

echo "📦 Container status:"
docker ps -a

# Optional: verify app startup (wait a few seconds then curl test)
echo "⏳ Waiting 5 seconds for app to start..."
sleep 5
echo "🌐 Testing Flask app endpoint:"
curl -s http://localhost:5050 || echo "⚠️ App may take longer to start or port is different."

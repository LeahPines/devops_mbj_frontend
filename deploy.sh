# Function to handle errors
handle_error() {
  echo "Error: $1"
  exit 1
}

# 4a. Stage, Commit, and Push to GitHub
if git diff-index --quiet HEAD --; then
  echo "No changes to commit."
else
  git add . || handle_error "Failed to stage changes."
  git commit -m "Automated commit" || handle_error "Failed to commit changes."
  git push origin main || handle_error "Failed to push changes."
fi

# 4b. Install Dependencies and Build the App
npm install || handle_error "Failed to install dependencies."
npm run build || handle_error "Build failed."

# 4c. Upload to GCS Bucket
gsutil -m cp -r ./build/* gs://leah-pines-bucket || handle_error "Failed to upload to GCS bucket."
echo "Build files uploaded successfully."

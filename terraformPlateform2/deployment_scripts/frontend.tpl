#!/bin/bash

# Update packages
sudo yum update -y

# Install Node.js and npm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
source ~/.bashrc
nvm install node

# Clone the React application from GitHub
git clone https://github.com/Dyabaulau/Archis9.git
cd Archis9/front

# Install dependencies
npm install

# Build the application
npm run build

# Start the application
npm start
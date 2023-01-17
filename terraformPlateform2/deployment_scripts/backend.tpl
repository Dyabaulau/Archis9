#!/bin/bash

# Update the package manager
sudo yum update -y

#Download get-pip to current directory. It won't install anything, as of now
curl -O https://bootstrap.pypa.io/get-pip.py

#Use python3.6 to install pip
python3 get-pip.py

# Install git
sudo yum install -y git

# Clone the react application from Github
git clone https://github.com/Dyabaulau/Archis9.git

# Move to the backend folder
cd Archis9/fast_api

pip3 install fastapi uvicorn pymongo sqlalchemy

# Start the server
uvicorn main:app --host 0.0.0.0
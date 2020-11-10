# Image Docker to be a Runner on GitHub.

This image comes with the following tools installed

- AWS CLI  
- Docker  
- Docker-Compose  
- Git  
- GitHub Runner  
- Terraform  
- Python3  
  
To work with multiple simultaneous runners you must duplicate the service block and change GITHUB_RUNNER_NAME, GITHUB_RUNNER_TOKEN and Volume ./work  

# Create Link for folders  
  
Create Link symbol for volumes in host  

ln -s /runner/work1/_temp/_github_home /github/home  
ln -s /runner/work1/_temp/_runner_file_commands /github/file_commands  
ln -s /runner/work1/syndikos/syndikos /github/workspace  
ln -s /home/PATH/TO/work1 /runner/work  

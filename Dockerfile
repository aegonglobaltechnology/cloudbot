FROM node:5
MAINTAINER David Bagan

RUN apt-get update

RUN apt-get update && \
    apt-get install -y python-pip && \
    pip install awscli
	
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
	
RUN npm install -g coffee-script
RUN npm install -g yo generator-hubot

# Create hubot user
RUN	useradd -d /cloudbot -m -s /bin/bash -U cloudbot

# Log in as hubot user and change directory
USER	cloudbot
WORKDIR /cloudbot

# Install hubot
RUN yo hubot --owner="David Bagan <fake.email@transamerica.com>" --name="cloudbot" --description="AGT Cloud Team's Hubot" --defaults

# Slack and AWS related adapters. More to come later
RUN npm install hubot-slack --save && npm install
RUN npm install hubot-github --save && npm install
#RUN npm install hubot-s3-brain --save && npm install
RUN npm install hubot-suggest --save && npm install

# Activate some built-in scripts
ADD hubot/hubot-scripts.json /cloudbot/
ADD hubot/external-scripts.json /cloudbot/
#COPY env.sh /cloudbot

RUN npm install cheerio --save && npm install

# Run HuBot
CMD bin/hubot -a slack
# CMD ["/bin/sh", "-c", "/cloudbot/env.sh; bin/hubot --adapter slack"]
# CMD ["/bin/sh", "-c", "aws s3 cp --region eu-west-2 s3://docker-aegon-repo/env.sh .; . ./env.sh; bin/hubot --adapter slack"]
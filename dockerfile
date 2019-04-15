# Use an official Python runtime as a base image
FROM python:3-alpine

#--------------------------- Set Arguments
# Environnement
ARG PROJECT_NAME='slack-archiver-bot'
# Logger
ARG LOG_FILENAME="app.log"
ARG LOG_LEVEL="WARNING"
# Api
ARG TITLE=$PROJECT_NAME
ARG VERSION
ARG DESCRIPTION
# Source Control
ARG VCS_URL
ARG VCS_REF
ARG BUILD_DATE
# Web Server
ARG PORT=
ARG DATABASE_PATH="slack.sqlite"

#--------------------------- Set Environment variables
# API KEY
ENV SLACK_API_TOKEN="<SHOULD BE SET IN THE BUILD COMMAND>"
# Logger
ENV LOG_FILENAME=$LOG_FILENAME
# Api
ENV TITLE=$TITLE
ENV VERSION=$VERSION
ENV DESCRIPTION=$DESCRIPTION
# Web Server
ENV PORT=$PORT

#--------------------------- Set Labels (see https://microbadger.com/labels)
LABEL maintainer="stevenaubertin@gmail.com" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name=$PROJECT_NAME \
      org.label-schema.description=$DESCRIPTION \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

#-------------------------------- Set Source
# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
# The files least likely to be changed should be in lower layers,
# while the files most likely to change should be added last.
COPY archivebot.py /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port available to the world outside this container
EXPOSE $PORT

# Run archivebot.py when the container launches
CMD ["python", "archivebot.py", "-l", $LOG_LEVEL, "-d", $DATABASE_PATH]
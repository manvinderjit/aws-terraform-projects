# Use alpine latest for base image
FROM alpine:latest

# Add label
LABEL purpose="Minimal base image with OpenJDK 21 for Spring Boot deployment"

# Install OpenJDK 21 and timezone data only
RUN apk add --no-cache openjdk21 tzdata

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk
ENV PATH="$JAVA_HOME/bin:$PATH"

# Set timezone to America/New_York (EST/EDT with daylight saving)
RUN cp /usr/share/zoneinfo/America/New_York /etc/localtime && \
    echo "America/New_York" > /etc/timezone
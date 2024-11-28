# Use a Python 3.9 slim image as base
FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Install essential system dependencies for Chrome and required libraries
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libfontconfig1 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libdrm2 \
    libgtk-3-0 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libx11-dev \
    unzip \
    fonts-liberation \
    libvulkan1 \
    xdg-utils \
    --no-install-recommends && \
    apt-get clean

# Install Google Chrome stable
RUN wget https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/linux64/chrome-linux64.zip && \
    unzip chrome-linux64.zip -d /usr/local/ && \
    rm chrome-linux64.zip && \
    ln -s /usr/local/chrome-linux64/chrome /usr/bin/google-chrome

# Install ChromeDriver
RUN mkdir -p /usr/local/bin && \
    wget https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip -d /usr/local/bin && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -rf chromedriver-linux64.zip /usr/local/bin/chromedriver-linux64

# Install Node.js and Newman (Postman CLI)
RUN apt-get update && apt-get install -y nodejs npm && \
    npm install -g newman

# Install Appium Server
RUN npm install -g appium

RUN pip install --upgrade pip
# Install Python dependencies
RUN pip install --no-cache-dir \
    # Testing Libraries
    pytest \
    pytest-bdd \
    selenium \
    robotframework \
    robotframework-seleniumlibrary \
    unittest2 \
    nose2 \
    tox \
    pytest-cov \
    flaky \
    pytest-mock \
    coverage \
    pytest-xdist \
    pytest-html \
    pytest-django \
    mock \
    flake8 \
    black \
    pylint \
    pytest-testinfra \
    ansible \
    markdown \
    requests \
    hypothesis \
    mypy \
    pyright \
    httpie \ 
    # Math/Operations Libraries
    numpy \
    # Web Development (for testing or automating browsers)
    flask \
    django \
    green \
    Appium-Python-Client 
       


# Set environment variable for headless Chrome
ENV DISPLAY=:99
ENV GOOGLE_CHROME_BIN=/usr/bin/google-chrome
ENV CHROME_DRIVER=/usr/local/bin/chromedriver

# Copy any additional files if necessary
COPY menu.sh /app/menu.sh

# Ensure that menu.sh is executable
RUN chmod +x /app/menu.sh

# Set entrypoint
ENTRYPOINT ["bash", "/app/menu.sh"]


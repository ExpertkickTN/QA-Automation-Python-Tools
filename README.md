# QA-Automation-Python-Tools
# 🚀 Kickstart Your QA Automation Journey with This All-in-One Docker Image! 🚀

If you’re a beginner in QA automation and want to learn or improve your testing skills, I’ve just created the perfect environment for you! 🎯

## 🔹 What’s inside:
- **UI Automation:** Selenium, Appium
- **BDD Testing:** Robot Framework, Pytest
- **API Testing:** Postman, Httpie
- **Unit Testing:** Pytest, Green, Rose2
- **Code Quality:** Flake8, Pylint
- **Infrastructure Testing:** Ansible, Testinfra

And Much More... All seamlessly packaged in an easy-to-use Docker container! 🧑‍💻

This Docker image is designed to make it easier for you to practice and experiment with test automation, without worrying about setting up multiple tools. Whether you’re testing APIs, web apps, or working on your first unit test, this setup is your one-stop solution! 🎉

## 📦 Features:
- Menu-driven interface for seamless test execution
- Ready-to-go environment for UI, API, BDD testing, and more!
- Full environment setup, just pull and start!

## 📥 Docker Pull Command

To get started with the **QA Automation Python Tools** Docker image, simply pull it using the following command:

```bash
docker pull expertkicktn/qa-automation-python-tools
```

Once the image is pulled, you can start using it for your testing automation setup!


## Selenium & Robot Framework Trick for Performance Boost 🚀
To make sure your tests run smoothly and avoid any unwanted notifications or crashes when using Selenium with Robot Framework, include this setup trick:

```bash
*** Variables ***
${options}  Evaluate sys.modules['selenium.webdriver'].ChromeOptions() sys

*** Test Setup ***
Set Browser Options

*** Keywords ***
Set Browser Options
    ${options}  Evaluate sys.modules['selenium.webdriver'].ChromeOptions() sys
    Call Method ${options} add_argument --disable-notifications
    Call Method ${options} add_argument --disable-infobars
    Call Method ${options} add_argument --disable-extensions
    Call Method ${options} add_argument --no-sandbox
    Call Method ${options} add_argument --headless
    Call Method ${options} add_argument --disable-dev-shm-usage
    Create WebDriver  Chrome  options=${options}

# Set Implicit Wait for ChromeDriver
Set Selenium Implicit Wait 15

*** Test Case ***
Example Test
    Open Browser  https://example.com  chrome
    # Your test steps here
    Close Browser
```
### Why Use This Setup?

- **Disables notifications, infobars, and extensions:** Avoids pop-ups and clutter.
- **Headless mode:** Runs the browser without opening a UI, boosting performance.
- **Implicit Wait:** Ensures Selenium waits up to 15 seconds for elements to load, which is especially helpful on the first run or for slower-loading pages.

Let’s make QA Automation easier and more accessible for everyone. Feel free to fork it, contribute, and let’s learn together! 🌱


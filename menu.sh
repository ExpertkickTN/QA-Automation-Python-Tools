#!/bin/bash

# Base directories
BASE_TEST_DIR="/app/tests"
LOG_DIR="/app/test_logs"
LOG_FILE="$LOG_DIR/test_script.log"

# Create necessary directories
mkdir -p "$BASE_TEST_DIR/unit_tests" \
         "$BASE_TEST_DIR/regression_tests" \
         "$BASE_TEST_DIR/bdd" \
         "$BASE_TEST_DIR/ui_tests" \
         "$BASE_TEST_DIR/api_tests" \
         "$BASE_TEST_DIR/misc_tests" \
	 "$BASE_TEST_DIR/code_quality_linting" \
	 "$BASE_TEST_DIR/property_based_type_checking" \
         "$LOG_DIR"

# Logging function
log_message() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate tool availability
validate_tool() {
    if ! command_exists "$1"; then
 echo "Error: $1 is not installed. Please install it before proceeding."
        log_message "Error: $1 is missing."
        exit 1
    fi
}

# Enhanced Menu

echo -e "\033[1;36m========= Python Testing Tools Menu =========\033[0m"
echo -e "\033[1;32mSelect a category of tests to view specific tools:\033[0m"
echo -e "\033[1;34m1) \033[0m\033[32mUnit Testing\033[0m"
echo -e "\033[1;34m2) \033[0m\033[32mRegression Testing\033[0m"
echo -e "\033[1;34m3) \033[0m\033[32mBehavior-Driven Development (BDD)\033[0m"
echo -e "\033[1;34m4) \033[0m\033[32mUI and Mobile Testing\033[0m"
echo -e "\033[1;34m5) \033[0m\033[32mCode Quality and Linting\033[0m"
echo -e "\033[1;34m6) \033[0m\033[32mProperty-Based and Type Checking\033[0m"
echo -e "\033[1;34m7) \033[0m\033[32mAPI Testing\033[0m"
echo -e "\033[1;34m8) \033[0m\033[32mInfrastructure and Miscellaneous\033[0m"
echo -e "\033[1;34m9) \033[0m\033[31mExit\033[0m"
echo -e "\033[1;36m=============================================\033[0m"

# Prompt for user input
read -p $'\033[1;33mChoose a category (1-9): \033[0m' category

if ! [[ "$category" =~ ^[1-9]$ ]]; then
    echo "Invalid category. Please enter a number between 1 and 9."
    log_message "Invalid category selection: $category"
    exit 1
fi

# Prompt for test case input
case $category in
1) test_file="$BASE_TEST_DIR/unit_tests/test_case.py";;
2) test_file="$BASE_TEST_DIR/regression_tests/test_case.py";;
3)
    echo "Choose a BDD framework:"
    echo "1) Behave (.feature)"
    echo "2) Robot Framework (.robot)"
    echo "3) Pytest-BDD (.py)"
    read -p "Select framework (1-3): " bdd_option
    case $bdd_option in
    1) test_file="$BASE_TEST_DIR/bdd/test_case.feature" ;;
    2) test_file="$BASE_TEST_DIR/bdd/test_case.robot" ;;
    3) test_file="$BASE_TEST_DIR/bdd/test_case.py" ;;
    *)
        echo "Invalid option for BDD framework."
        log_message "Invalid BDD framework selection: $bdd_option"
        exit 1
        ;;
    esac
    ;;
4) test_file="$BASE_TEST_DIR/ui_tests/test_case.py";;
5) test_file="$BASE_TEST_DIR/code_quality_linting/test_case.py";;
6) test_file="$BASE_TEST_DIR/property_based_type_checking/test_case.py";;
7)
         echo "========= API Testing ========="
    echo "1) Postman"
    echo "2) Pytest with API Testing"
    echo "3) HTTPie"
    read -p "Choose a tool (1-3): " api_option
    
        case $api_option in
    1)
echo "Please paste your Postman collection JSON below using your mouse:"
       echo "Press CTRL+D to finish input."
    # Read Postman collection from user input and save to a file
    collection_file="$BASE_TEST_DIR/misc_tests/postman_collection.json"
    cat > "$collection_file"

    # Ensure the file is not empty
    if [[ ! -s "$collection_file" ]]; then
        echo "Error: The Postman collection is empty."
        log_message "Error: Empty Postman collection provided."
        exit 1
    fi

    echo "Running Postman collection from file: $collection_file..."

    # Validate Newman tool installation
    validate_tool "newman"  && newman run "$collection_file"
    log_message "Postman collection executed."
 ;;
    2)
    # Simple Pytest API testing (already covered in previous example)
    echo "Running Pytest API test..."
    validate_tool "pytest" && pytest "$BASE_TEST_DIR/api_tests/test_api.py"
    log_message "Pytest API tests executed successfully."
    ;;
    3)
         # HTTPie Testing (Dynamic URL and method input)
            echo "Running HTTPie test..."
            log_message "Running HTTPie test..."

            # Prompt the user for the full HTTP request (method, URL, headers, data, etc.)
            echo "Please enter the full HTTP request (e.g., GET http://github.com or POST http://example.com data='yourdata'):"
            read -p "Enter HTTP request: " user_input

            # Validate that the user input is not empty
            if [[ -z "$user_input" ]]; then
                echo -e "\033[0;31mError: You must provide a valid HTTP request.\033[0m"
                log_message "Error: No HTTP request provided for HTTPie test."
                exit 1
            fi

            # Run HTTPie with the user's input (passing it as is)
            echo "Running HTTPie with the following request: $user_input"
            validate_tool "http" && http $user_input | tee -a "$LOG_FILE"

            log_message "HTTPie test executed successfully with request: $user_input."
            ;;
      
    esac
    exit 0
    ;;
8)
    echo "Choose an Infrastructure or Miscellaneous tool:"
    echo "1) Testinfra (.py)"
    echo "2) Ansible (.yml)"
    echo "3) Postman Collections (.json)"
    echo "4) Markdown Documentation (.md)"
    read -p "Select a tool (1-4): " misc_option
    case $misc_option in
    1) test_file="$BASE_TEST_DIR/misc_tests/test_case.py" ;;
    2) test_file="$BASE_TEST_DIR/misc_tests/playbook.yml" ;;
    3) test_file="$BASE_TEST_DIR/misc_tests/postman_collection.json" ;;
    4) test_file="$BASE_TEST_DIR/misc_tests/documentation.md" ;;
    *)
        echo "Invalid option for Infrastructure/Miscellaneous."
        log_message "Invalid option for Infrastructure/Miscellaneous: $misc_option"
        exit 1
        ;;
    esac
    ;;
9)
    echo "Exiting. Goodbye!"
    log_message "Exit selected. Goodbye!"
    exit 0;;
*)
    echo "Unexpected error. Exiting."
    log_message "Unexpected error in category selection."
    exit 1;;
esac

echo "============================================="
echo "Please write or paste your test using your mouse case below. When done, press CTRL+D to finish input."

# Capture the test case
if ! cat > "$test_file"; then
    echo "Error writing to $test_file. Please check permissions."
    log_message "Error: Failed to write to $test_file"
    exit 1
fi
log_message "Test case written to $test_file."

# Submenu for tool execution
case $category in
1)
    echo "========= Unit Testing Tools ========="
echo "1) Pytest"
echo "2) Unittest"
echo "3) Nose2"
echo "4) Green"
echo "5) Run All Unit Tests"
read -p "Choose a tool (1-5): " unit_option

case $unit_option in
1)
    echo "Running tests with Pytest..."
    validate_tool "pytest" && pytest -v "$BASE_TEST_DIR/unit_tests"
    ;;
2)
    echo "Running tests with Unittest..."
    validate_tool "python" && python -m unittest discover "$BASE_TEST_DIR/unit_tests"
    ;;
3)
    echo "Running tests with Nose2..."
    validate_tool "nose2" && nose2 -s "$(dirname "$test_file")"
    ;;
4)
    echo "Running tests with Green..."
    validate_tool "green" && green "$BASE_TEST_DIR/unit_tests"
    ;;
5)
    echo "Running tests with all tools: Pytest, Unittest, Green, and Nose2..."
    validate_tool "pytest"
    validate_tool "python"
    validate_tool "green"
    validate_tool "nose2"

    # Run tests with all tools sequentially
    echo "Running tests with Pytest..."
    pytest -v "$BASE_TEST_DIR/unit_tests" && \
    echo "Running tests with Unittest..." && \
    python -m unittest discover "$BASE_TEST_DIR/unit_tests" && \
    echo "Running tests with Green..." && \
    green "$BASE_TEST_DIR/unit_tests" && \
    echo "Running tests with Nose2..." && \
    nose2 -s "$(dirname "$test_file")"
    ;;
*)
    echo "Invalid option."
    ;;
esac

    ;;
2)
    echo "========= Regression Testing Tools ========="
    echo "1) Tox"
    echo "2) Coverage"
    echo "3) Doctest"
    read -p "Choose a tool (1-3): " regression_option
    case $regression_option in
    1) validate_tool "tox" && tox ;;
    2) validate_tool "coverage" && coverage run -m pytest && coverage report ;;
    3) validate_tool "python" && python -m doctest -v "$test_file";;
    *) echo "Invalid option." ;;
    esac
    ;;
3)
    case $bdd_option in
    1) validate_tool "behave" && behave ;;
    2) validate_tool "robot" && robot "$BASE_TEST_DIR/bdd/" ;;
    3) validate_tool "pytest" && pytest -v "$BASE_TEST_DIR/bdd/" ;;
    esac
    ;;
4)
    echo "========= UI Testing Tools ========="
echo "1) Selenium"
echo "2) Appium"
echo "3) Run All UI and Mobile Tests"
read -p "Choose a tool (1-3): " ui_option

case $ui_option in
    1)
        validate_tool "python"
        python "$test_file"  # Run Selenium test script
        ;;
    2)
        validate_tool "Appium-Python-Client"
        appium --port 4723 &  # Start Appium server in the background
        python "$test_file"   # Run the Appium test script
        pkill -f appium       # Stop Appium server after test
        ;;
    3)
        validate_tool "python"
        validate_tool "Appium-Python-Client"
        appium --port 4723 &  # Start Appium server in the background
        python "$test_file"  # Run Selenium test script
        python "$BASE_TEST_DIR/ui_tests/test_appium.py"    # Run Appium test script
        pkill -f appium       # Stop Appium server after tests
        ;;
    *)
        echo "Invalid option."
        ;;
esac
;;
5)
    echo "========= Code Quality and Linting ========="
    echo "1) Flake8"
    echo "2) Black"
    echo "3) Pylint"
    read -p "Choose a tool (1-3): " lint_option
    case $lint_option in
    1) validate_tool "flake8" && flake8 --verbose . ;;
    2) validate_tool "black" && black . ;;
    3) validate_tool "pylint" && pylint . ;;
    *) echo "Invalid option." ;;
    esac
    ;;
6)
 echo "========= Property-Based and Type Checking ========="
    echo "1) Hypothesis"
    echo "2) MyPy"
    echo "3) Pyright"
    read -p "Choose a tool (1-3): " type_option
    case $type_option in
    1) validate_tool "pytest" && pytest --hypothesis-show-statistics ;;
    2) validate_tool "mypy" && mypy . ;;
    3) validate_tool "pyright" && pyright ;;
    *) echo "Invalid option." ;;
    esac
    ;;

8)
    case $misc_option in
    1) validate_tool "pytest" && pytest -v "$test_file" ;;
    2) validate_tool "ansible-playbook" && ansible-playbook "$BASE_TEST_DIR/misc_tests/playbook.yml" ;;
    3) validate_tool "newman" && newman run "$BASE_TEST_DIR/misc_tests/postman_collection.json" ;;
    4) echo "Markdown documentation saved to $test_file." ;;
    esac
    ;;
*)
    echo "Invalid category."
    log_message "Invalid tool selection."
    exit 1
    ;;
esac

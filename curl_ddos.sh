#!/bin/bash

# Default configuration
numberOfRequests=10
curlCommand=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--number)
            numberOfRequests="$2"
            shift # past argument
            shift # past value
            ;;
        -c|--curl)
            curlCommand="$2"
            shift # past argument
            shift # past value
            ;;
        -h|--help)
            echo "Usage: $0 [-n|--number NUM_REQUESTS] [-c|--curl CURL_COMMAND] [-h|--help]"
            echo "  -n, --number    Number of concurrent requests (default: 10)"
            echo "  -c, --curl      Custom curl command (with or without 'curl' prefix)"
            echo "  -h, --help      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 -n 5 -c \"'https://httpbin.org/get'\""
            echo "  $0 -n 10 -c \"curl 'https://api.example.com/data' -X POST -H 'Content-Type: application/json' --data '{\\\"key\\\":\\\"value\\\"}'\""
            echo "  $0 -n 3 -c \"'https://jsonplaceholder.typicode.com/posts/1' -X GET\""
            echo ""
            echo "For multi-line curl commands, put the entire command in quotes without line breaks:"
            echo "  $0 -n 5 -c \"curl 'https://example.com' -X POST -H 'Content-Type: application/json' --data '{...}'\""
            exit 0
            ;;
        *)
            echo "Unknown option $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Validate numberOfRequests is a positive number
if ! [[ "$numberOfRequests" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Number of requests must be a positive integer"
    exit 1
fi

# Set default curl command if none provided
if [[ -z "$curlCommand" ]]; then
    curlCommand="'https://jsonplaceholder.typicode.com/posts/1'"
else
    # Remove "curl" prefix if user included it
    curlCommand=$(echo "$curlCommand" | sed 's/^[[:space:]]*curl[[:space:]]*//')
    # Clean up any line continuation characters and normalize whitespace
    curlCommand=$(echo "$curlCommand" | tr '\n' ' ' | sed 's/\\[[:space:]]*/ /g' | sed 's/[[:space:]]\+/ /g')
fi

echo "Bot Configuration (Concurrent):"
echo "Number of requests: $numberOfRequests"
echo "Curl command: curl -w \"%{http_code}\" -o /dev/null -s $curlCommand"
echo "All requests will fire simultaneously"
echo "=============================="

# Debug: Show the cleaned command
if [[ "$curlCommand" != "'https://jsonplaceholder.typicode.com/posts/1'" ]]; then
    echo "Debug - Cleaned curl command:"
    echo "$curlCommand"
    echo "=============================="
fi

# Function to make a single request
make_request() {
    local request_num=$1
    local start_time=$(date +%s)
    
    echo "[$(date '+%H:%M:%S')] 🚀 Starting Request #$request_num"
    
    # Get only the HTTP status code using -w flag and -o /dev/null to suppress body
    status_code=$(
        # Dynamic curl command with status code extraction
        eval "curl -w \"%{http_code}\" -o /dev/null -s $curlCommand"
    )
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Add status emoji based on status code
    local status_emoji="❓"
    if [[ $status_code =~ ^2[0-9]{2}$ ]]; then
        status_emoji="✅"
    elif [[ $status_code =~ ^4[0-9]{2}$ ]]; then
        status_emoji="⚠️"
    elif [[ $status_code =~ ^5[0-9]{2}$ ]]; then
        status_emoji="❌"
    fi
    
    echo "[$(date '+%H:%M:%S')] $status_emoji Request #$request_num completed in ${duration}s - Status: $status_code"
}

# Fire ALL requests concurrently (no delays)
echo "[$(date '+%H:%M:%S')] 🎯 Firing all $numberOfRequests requests concurrently..."

for i in $(seq 1 $numberOfRequests)
do
    make_request $i &  # Fire immediately in background
done

echo "[$(date '+%H:%M:%S')] 🏁 All requests fired! Waiting for responses..."

# Wait for all background processes to complete
wait

echo "[$(date '+%H:%M:%S')] 🎉 All concurrent requests completed!"

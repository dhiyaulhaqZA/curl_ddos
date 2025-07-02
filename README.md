# curl_ddos

A Bash script for sending concurrent HTTP requests using curl to test server load and performance. This tool is designed for educational purposes and legitimate load testing of your own services.

## ⚠️ Important Disclaimer

This tool is intended for:
- Testing your own servers and applications
- Educational purposes and learning about concurrent requests
- Performance testing with proper authorization

**Do NOT use this tool for:**
- Testing servers you don't own without explicit permission
- Malicious attacks or actual DDoS attempts
- Any illegal activities

Always ensure you have proper authorization before testing any server.

## Features

- 🚀 **Concurrent requests**: Send multiple HTTP requests simultaneously
- 📊 **Real-time status**: View request progress with timestamps and status codes
- 🎯 **Flexible configuration**: Customize number of requests and curl commands
- 📈 **Status indicators**: Color-coded emojis for different HTTP status codes
- ⏱️ **Performance metrics**: Track request duration and completion times

## Installation

1. Clone or download the script:
```bash
git clone https://github.com/dhiyaulhaqZA/curl_ddos.git
cd curl_ddos
```

2. Make the script executable:
```bash
chmod +x curl_ddos.sh
```

## Usage

### Basic Syntax
```bash
./curl_ddos.sh [-n|--number NUM_REQUESTS] [-c|--curl CURL_COMMAND] [-h|--help]
```

### Parameters

| Parameter | Short | Description | Default |
|-----------|-------|-------------|---------|
| `--number` | `-n` | Number of concurrent requests | 10 |
| `--curl` | `-c` | Custom curl command (with or without 'curl' prefix) | `https://jsonplaceholder.typicode.com/posts/1` |
| `--help` | `-h` | Show help message | - |

### Examples

#### 1. Simple GET request with default settings
```bash
./curl_ddos.sh
```

#### 2. Custom number of requests
```bash
./curl_ddos.sh -n 5 -c "https://httpbin.org/get"
```

#### 3. POST request with JSON data
```bash
./curl_ddos.sh -n 10 -c "curl 'https://api.example.com/data' -X POST -H 'Content-Type: application/json' --data '{\"key\":\"value\"}'"
```

#### 4. GET request with custom headers
```bash
./curl_ddos.sh -n 3 -c "'https://jsonplaceholder.typicode.com/posts/1' -X GET -H 'Authorization: Bearer token123'"
```

#### 5. Complex request with multiple parameters
```bash
./curl_ddos.sh -n 5 -c "curl 'https://example.com/api' -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer token' --data '{\"test\":\"data\"}'"
```

## Output Format

The script provides real-time feedback with the following information:

### Configuration Display
```
Bot Configuration (Concurrent):
Number of requests: 10
Curl command: curl -w "%{http_code}" -o /dev/null -s https://example.com
All requests will fire simultaneously
==============================
```

### Request Progress
```
[14:30:15] 🚀 Starting Request #1
[14:30:15] 🚀 Starting Request #2
[14:30:15] 🏁 All requests fired! Waiting for responses...
[14:30:16] ✅ Request #1 completed in 1s - Status: 200
[14:30:16] ✅ Request #2 completed in 1s - Status: 200
[14:30:16] 🎉 All concurrent requests completed!
```

### Status Code Indicators

| Emoji | Status Code Range | Description |
|-------|------------------|-------------|
| ✅ | 2xx | Success responses |
| ⚠️ | 4xx | Client error responses |
| ❌ | 5xx | Server error responses |
| ❓ | Other | Unknown or unexpected responses |

## How It Works

1. **Argument Parsing**: The script processes command-line arguments to configure the test
2. **Command Validation**: Validates the number of requests and cleans the curl command
3. **Concurrent Execution**: Launches all requests simultaneously using background processes (`&`)
4. **Real-time Monitoring**: Each request reports its progress with timestamps
5. **Status Collection**: Uses curl's `-w` flag to capture HTTP status codes
6. **Synchronization**: Waits for all background processes to complete using `wait`

## Command Processing

The script automatically:
- Removes the `curl` prefix if included in the command
- Cleans up line continuation characters and normalizes whitespace
- Adds necessary flags for status code extraction (`-w "%{http_code}" -o /dev/null -s`)

## Requirements

- Bash shell (tested on macOS and Linux)
- curl command-line tool
- Basic Unix utilities (date, seq, etc.)

## Performance Considerations

- **Resource Usage**: Each concurrent request spawns a separate process
- **System Limits**: Be aware of your system's process and file descriptor limits
- **Network Impact**: High concurrency may saturate your network connection
- **Target Server**: Ensure the target server can handle the load

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x curl_ddos.sh
   ```

2. **Invalid Number of Requests**
   - Ensure the number is a positive integer
   - Example: `-n 10` not `-n 0` or `-n -5`

3. **Curl Command Errors**
   - Check your curl syntax
   - Ensure URLs are properly quoted
   - Test the curl command manually first

4. **Network Timeouts**
   - Add timeout parameters to your curl command
   - Example: `--connect-timeout 10 --max-time 30`

### Debug Mode

The script includes debug output for custom curl commands that shows the cleaned command before execution.

## License

This project is provided as-is for educational and testing purposes. Use responsibly and in accordance with applicable laws and regulations.

## Contributing

Feel free to submit issues and enhancement requests!

---

**Remember**: Always test responsibly and only against servers you own or have explicit permission to test.

# AWS Event Log Processor

## Overview

This Ruby script processes AWS event logs. It downloads a tar file containing gzipped JSON files, extracts and unzips them, then collects and prints a report of unique AWS events per region. Additionally, it highlights events that exceed a specified threshold to help identify potential issues.

## Features

- Downloads and extracts log files from a provided URL
- Unzips JSON files for processing
- Collects unique AWS events and counts occurrences by region
- Prints a report in a sorted format
- Highlights events that exceed a threshold for easier problem identification

## Usage

1. **Ensure Ruby 3.2.x or higher is installed.**

2. **Download the script**:
   ```
   curl -O https://example.com/downloads/process_aws_events.rb
   ```

3. **Run the script**:
   ```
   ruby process_aws_events.rb
   ```

## Output

### Report Format

```
regionName
eventName: count
eventName: count
...
. . .
```

Example:
```
us-east-2
GetAccountSummary: 485
GetAccountPasswordPolicy: 986
ListBuckets: 2281
. . .
```

### Potential Issues

Includes an extra feature to highlight events exceeding a certain threshold, useful for support engineers in identifying recurring issues.

```
Potential Issues Detected (Events Exceeding Threshold of 1000 Occurrences):
Region: us-east-1
  ListBuckets: 2281 occurrences
. . .
```

## Explanation

1. **Download and Extract**:
   - Downloads the tar file from the specified URL.
   - Extracts the contents into a directory.

2. **Unzip JSON Files**:
   - Unzips all `.json.gz` files into a directory.

3. **Process Events**:
   - Reads each JSON file, collects and counts events by region.

4. **Generate Report**:
   - Prints a sorted report of events per region.
   - Highlights events exceeding the defined threshold.

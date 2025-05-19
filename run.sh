#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
logs_dir="$script_dir/logs"
mkdir -p $logs_dir

# JAR paths
AUTHOR_JAR="$script_dir/author/aem-author-p4502.jar"
PUBLISH_JAR="$script_dir/publish/aem-publish-p4503.jar"

# Commands
AUTHOR_CMD="java -jar \"$AUTHOR_JAR\" -r author,stage -fork -forkargs -- -Xdebug -Xrunjdwp:transport=dt_socket,address=30303,suspend=n,server=y -Dfile.encoding=UTF8"
PUBLISH_CMD="java -jar \"$PUBLISH_JAR\""

# Logs and PIDs
AUTHOR_LOG="$logs_dir/author.log"
PUBLISH_LOG="$logs_dir/publish.log"
AUTHOR_PID="$logs_dir/author.pid"
PUBLISH_PID="$logs_dir/publish.pid"

# Functions
start_author() {
  if [[ -f "$AUTHOR_JAR" ]]; then
    echo "Starting AEM Author in background..."
    nohup bash -c "$AUTHOR_CMD" > "$AUTHOR_LOG" 2>&1 &
    echo $! > "$AUTHOR_PID"
    echo "Author PID: $(cat $AUTHOR_PID)"
  else
    echo "ERROR: File $AUTHOR_JAR not found."
    exit 1
  fi
}

start_publish() {
  if [[ -f "$PUBLISH_JAR" ]]; then
    echo "Starting AEM Publish in background..."
    nohup bash -c "$PUBLISH_CMD" > "$PUBLISH_LOG" 2>&1 &
    echo $! > "$PUBLISH_PID"
    echo "Publish PID: $(cat $PUBLISH_PID)"
  else
    echo "ERROR: File $PUBLISH_JAR not found."
    exit 1
  fi
}

stop_author() {
  if [[ -f "$AUTHOR_PID" ]]; then
    kill "$(cat "$AUTHOR_PID")" && echo "Author stopped." || echo "Failed to stop Author."
    rm -f "$AUTHOR_PID"
  else
    echo "Author is not running or no PID file found."
  fi
}

stop_publish() {
  if [[ -f "$PUBLISH_PID" ]]; then
    kill "$(cat "$PUBLISH_PID")" && echo "Publish stopped." || echo "Failed to stop Publish."
    rm -f "$PUBLISH_PID"
  else
    echo "Publish is not running or no PID file found."
  fi
}

status_author() {
  if [[ -f "$AUTHOR_PID" ]]; then
    PID=$(cat "$AUTHOR_PID")
    if ps -p $PID > /dev/null 2>&1; then
      echo "Author is running (PID $PID)."
    else
      echo "Author PID file exists but process $PID is not running."
    fi
  else
    echo "Author is not running."
  fi
}

status_publish() {
  if [[ -f "$PUBLISH_PID" ]]; then
    PID=$(cat "$PUBLISH_PID")
    if ps -p $PID > /dev/null 2>&1; then
      echo "Publish is running (PID $PID)."
    else
      echo "Publish PID file exists but process $PID is not running."
    fi
  else
    echo "Publish is not running."
  fi
}

print_help() {
  echo "Usage: $(basename "$0") [command] [target]"
  echo "Commands:"
  echo "  start   [author|publish|both]   Start AEM instance(s)"
  echo "  stop    [author|publish|both]   Stop AEM instance(s)"
  echo "  status  [author|publish|both]   Status AEM instance(s)"
  echo "  help                            Show this help message"
}

# Command logic
COMMAND="$1"
TARGET="$2"

case "$COMMAND" in
  start)
    case "$TARGET" in
      "" | "author")
        start_author
        ;;
      "publish")
        start_publish
        ;;
      "both")
        start_author
        start_publish
        ;;
      *)
        echo "Invalid target for start: $TARGET"
        print_help
        exit 1
        ;;
    esac
    ;;
  stop)
    case "$TARGET" in
      "" | "author")
        stop_author
        ;;
      "publish")
        stop_publish
        ;;
      "both")
        stop_author
        stop_publish
        ;;
      *)
        echo "Invalid target for stop: $TARGET"
        print_help
        exit 1
        ;;
    esac
    ;;
  status)
    case "$TARGET" in
      "" | "author")
        status_author
        ;;
      "publish")
        status_publish
        ;;
      "both")
        status_author
        status_publish
        ;;
      *)
        echo "Invalid target for status: $TARGET"
        print_help
        exit 1
        ;;
    esac
  ;;
  help | *)
    print_help
    ;;
esac

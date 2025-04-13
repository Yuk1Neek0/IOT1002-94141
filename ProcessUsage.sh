#!binbash

# Log file with current date
LOG_FILE=$HOMEProcessUsageReport-$(date +%Y-%m-%d).log

# Get top 5 CPU-consuming processes
TOP_PROCESSES=$(ps -eo pid,user,%cpu,start --sort=-%cpu  head -n 6)

# Show the processes
echo Top 5 CPU-consuming processes
echo $TOP_PROCESSES

echo Kill these processes (yesno)
read RESPONSE

if [[ $RESPONSE != yes ]]; then
    echo No processes killed. Exiting.
    exit 0
fi

# Counter for killed processes
KILL_COUNT=0

echo $TOP_PROCESSES  tail -n +2  while read PID USER CPU START; do
    if [[ $USER != root ]]; then
        DEPARTMENT=$(id -gn $USER)
        KILL_TIME=$(date)
        echo User $USER, Started $START, Killed $KILL_TIME, Dept $DEPARTMENT  $LOG_FILE
        kill -9 $PID
        ((KILL_COUNT++))
    fi
done

echo $KILL_COUNT processes killed. Exiting.

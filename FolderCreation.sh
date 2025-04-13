#!/bin/bash

# Array of departments
departments=("HR" "IT" "Finance" "Executive" "Administrative" "CallCentre")

# Path to main directory
main_dir="/EmployeeData"

# Create the main directory
mkdir -p "$main_dir"

# Counter for created folders
folder_count=0

# Loop through departments to create subdirectories
for dept in "${departments[@]}"; do
    folder="$main_dir/$dept"
    
    # Create folder
    mkdir -p "$folder"

    # Apply permissions
    if [[ "$dept" == "HR" || "$dept" == "Executive" ]]; then
        # Sensitive folders
        chmod -R 760 "$folder"
    else
        # Non-sensitive folders
        chmod -R 764 "$folder"
    fi

    # Ensure department group exists, if not, create it
    if ! getent group "$dept" > /dev/null; then
        groupadd "$dept"
    fi

    # Change group ownership to the department
    chown -R root:"$dept" "$folder"

    # Count the folder
    ((folder_count++))
done

# Final message
echo "$folder_count folders were created under $main_dir with appropriate permissions and ownership."

# End of script

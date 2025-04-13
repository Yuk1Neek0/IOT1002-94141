#!/bin/bash

#A00312234 Sikai Han
newUsers=0  #sum of new users added succsessfully
newGroups=0 #sum of new groups added succsessfully

inputFile="EmployeeNames.csv"  #employname file

#while loop,read every row except first row
while IFS=, read -r firstName lastName department #read firstname,lastname and department divided by ',' in file
do
    if [[ "$firstName" == "FirstName" ]]; then    #skip first row
    continue
    fi
    
    userName="${firstName:0:1}${lastName:0:7}"    #combine first character of first name and first-seven characters of last name
    
    #add user
    if id "$userName"; then                       
       echo "Error: user '$userName' already exist." #if username has exist, print error message
    
       else
       useradd "$userName"			     #if username has not exist 
       ((newUsers++))				     # counter newusers ++
    fi
    
    #add group
    departmentSanitized=$(echo "$department" | tr -cd '[:alnum:]_-')  #sanitizing "$department",otherwise terminal shows "' is not a valid group name"
    if getent group "$departmentSanitized"; then	              
       echo "Error: department '$departmentSanitized' already exist." #if group has exist, print error message
    
    else			
	groupadd "$departmentSanitized"				      #if group has not exist
        ((newGroups++))						      #counter newgroups ++
    fi
    
    #assign user to group
    currentGroup=$(id -gn "$userName")				      #get current group of user
    if [[ "$currentGroup" != "$departmentSanitized" ]]; then
        usermod -g "$departmentSanitized" "$userName"		      #if user is not in department group
    else
        echo "Error : User '$userName' is already in the group '$departmentSanitized'."  #if user has already in group
    fi

done < "$inputFile"  	#read information from employeename

echo "User adding process compelete! $newUsers new users added and          
$newGroups new groups created." #final output new users and new groups

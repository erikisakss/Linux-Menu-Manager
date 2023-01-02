#!/bin/bash
#Skapad av Erik Isaksson & Mika Pärssinen Grupp: C7

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

MenuFunction() {
    #Initialize the x variable before the loop
    declare x
    while [[ $x != "ex" ]]; do
        updatedb
        clear
        echo "##########################################################################"
        echo "                              SYSTEM MANAGER                              "
        echo "##########################################################################"

        echo -e "\n${GREEN}ni${NC} - Network Info   (Displays Network Information)"
        echo -e "\n${GREEN}au${NC} - Add User       (Creates a new user)"
        echo -e "${GREEN}lu${NC} - List User      (Lists all login users)"
        echo -e "${GREEN}vu${NC} - View User      (View User Properties)"
        echo -e "${GREEN}mu${NC} - Modify User    (Modify User Properties)"
        echo -e "${GREEN}du${NC} - Delete User    (Deletes a login user)"
        echo -e "\n${GREEN}ag${NC} - Add Group      (Creates a new group)"
        echo -e "${GREEN}lg${NC} - List Group     (Lists all group, not system groups)"
        echo -e "${GREEN}vg${NC} - View Group     (Lists all users in a group)"
        echo -e "${GREEN}mg${NC} - Modify Group   (Add/Remove user to/from a group)"
        echo -e "${GREEN}dg${NC} - Delete Group   (Deletes a group, not system groups)"
        echo -e "\n${GREEN}af${NC} - Add Folder     (Creates a new folder)"
        echo -e "${GREEN}lf${NC} - List Folder    (View content of a folder)"
        echo -e "${GREEN}vf${NC} - View Folder    (View folder properties)"
        echo -e "${GREEN}mf${NC} - Modify Folder  (Modify folder properties)"
        echo -e "${GREEN}df${NC} - Delete Folder  (Deletes a folder)"
        echo -e "\n${RED}ex${NC} - EXIT           (Exit System Manager)"

        echo -e "\nChoose a command: "
        read x

        case $x in

        ni)
            NetworkFunction
            BackToMenu
            ;;

        au)
            AddUserFunction
            BackToMenu
            ;;

        lu)
            ListUserFunction
            BackToMenu
            ;;

        vu)
            ListUserAttributes
            BackToMenu
            ;;

        mu)
            ModifyUserFunction
            BackToMenu
            ;;

        du)
            DeleteUser
            BackToMenu
            ;;

        ag)
            AddGroup
            BackToMenu
            ;;

        lg)
            ListGroup
            BackToMenu
            ;;

        vg)
            ViewGroup
            BackToMenu
            ;;

        mg)
            ModifyGroup
            BackToMenu
            ;;

        dg)
            DeleteGroup
            BackToMenu
            ;;

        af)
            FolderAdd
            BackToMenu
            ;;

        lf)
            FolderList
            BackToMenu
            ;;

        vf)
            FolderView
            BackToMenu
            ;;

        mf)
            FolderModify
            BackToMenu
            ;;

        df)
            FolderDelete
            BackToMenu
            ;;

        ex)
            echo "Shuting down program..."
            sleep 2
            echo "..."
            sleep 2
            echo ".."
            sleep 2
            echo "."
            sleep 1
            echo "bye!"
            ;;

        *)
            echo "Enter a valid command!"
            BackToMenu
            ;;

        esac

    done

}

AddUserFunction() {
    clear
    echo "Pick a Username: "
    read username
    useradd -m $username
    echo "Pick a Password: "
    passwd $username

}

ListUserFunction() {
    clear
    echo "List of all users: "
    awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd
}

ListUserAttributes() {
    clear
    echo "Which user would you like to view? "
    awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd
    echo -e "Pick a user: \n"
    read username
    UserID=$(getent passwd $username | cut -d ":" -f 3)
    GroupID=$(getent passwd $username | cut -d ":" -f 4)
    Groups=$(groups $username | cut -d ":" -f 2)
    Comments=$(getent passwd $username | cut -d ":" -f 5)
    HomeDirectory=$(getent passwd $username | cut -d ":" -f 6)
    ShellDirectory=$(getent passwd $username | cut -d ":" -f 7)

    echo -e "\nUsername: $username"
    echo "User ID: $UserID"
    echo "Group ID: $GroupID"
    echo "Comments: $Comments"
    echo "Groups: $Groups"
    echo "Home Directory: $HomeDirectory"
    echo "Shell: $ShellDirectory"

}

ModifyUserFunction() {
    clear
    echo "Which user would you like to modify? "
    awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd
    echo -e "Pick a user: \n"
    read username
    UserID=$(getent passwd $username | cut -d ":" -f 3)
    GroupID=$(getent passwd $username | cut -d ":" -f 4)
    Comments=$(getent passwd $username | cut -d ":" -f 5)
    HomeDirectory=$(getent passwd $username | cut -d ":" -f 6)
    ShellDirectory=$(getent passwd $username | cut -d ":" -f 7)

    echo -e "\nUsername: $username"
    echo "Password: *******"
    echo "User ID: $UserID"
    echo "Group ID: $GroupID"
    echo "Home Directory: $HomeDirectory"
    echo "Shell: $ShellDirectory"
    echo -e "\n Which attribute would you like to modify?"
    echo -e "\n -u for Username"
    echo "p for Password"
    echo "ui for User ID"
    echo "gi for Group ID"
    echo "c for Comments"
    echo "hd for Home Directory"
    echo "sd for Shell Directory"
    echo "exit to exit Modify User"
    declare info
    while [[ $info != "exit" ]]; do
        echo -e "\nChoose the attribute to modify: "
        read info

        case $info in
        #Changes the username
        u)
            echo "Current Username: $username"
            echo "Enter a new Username: "
            read newUsername
            usermod -l $newUsername $username

            ;;
        #Changes the password
        p)
            echo "Enter a new password: "
            read newPassword
            passwd $username
            ;;

        #Changes the User ID
        ui)
            echo "Current User ID: $UserID"
            echo "Enter a new User ID: "
            read newUserID
            usermod -u $newUserID $username
            ;;
        #Changes the Group ID
        gi)
            echo "Current Group ID: $GroupID"
            echo "Enter a new Group ID: "
            read newGroupID
            usermod -g $newGroupID $username
            ;;
        #Changes the Comments
        c)
            echo "Current Comments: $Comments"
            echo "Enter a new Comment: "
            read newComments
            usermod -c "$newComments" $username
            ;;
        #Changes the Home Directory
        hd)
            echo "Current Home Directory: $HomeDirectory"
            echo "Enter a new Home Directory: "
            read newHomeDirectory
            usermod -d $newHomeDirectory $username
            ;;
        #Changes the Shell Directory
        sd)
            echo "Current Shell Directory: $ShellDirectory"
            echo "Enter a new Shell Directory: "
            read newShellDirectory
            usermod -s $newShellDirectory $username
            ;;
        #Exits the menu
        exit)
            echo "Exiting Modification Menu"

            ;;
        #If the input is invalid
        *)
            echo "Invalid input"
            ;;
        esac
    done

}

DeleteUser() {
    clear
    echo "Which user would you like to delete? "
    awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd
    echo -e "Pick a user: \n"
    read username
    userdel -r $username
    echo "User $username is deleted!"
}

AddGroup() {
    clear
    echo "Pick a Groupname: "
    read groupname
    groupadd $groupname
    echo "Group $groupname is created!"
}

ListGroup() {
    #Lists all groups (except root)
    clear
    awk -F: '($3>=1000)&&($1!="nogroup"){print $1}' /etc/group

}

ViewGroup() {
    #View Users in Group and Group ID
    clear
    echo "Which group would you like to view? "
    awk -F: '($3>=1000)&&($1!="nogroup"){print $1}' /etc/group
    echo -e "Pick a group: \n"
    read groupname
    GroupID=$(getent group $groupname | cut -d ":" -f 3)
    PrimaryGroupMember=$(awk -F: -v GroupID=$GroupID '($4==GroupID){print $1}' /etc/passwd | tr '\n' ' ')
    GroupMembers=$(getent group $groupname | cut -d ":" -f 4)
    echo -e "\nGroupname: $groupname"
    echo "Group ID: $GroupID"
    echo "Primary Group Member: $PrimaryGroupMember"
    echo "Group Members: $GroupMembers"
}

ModifyGroup() {
    clear
    echo "Which group would you like to modify? "
    awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/group
    echo -e "Pick a group: \n"
    read groupname
    GroupID=$(getent group $groupname | cut -d ":" -f 3)
    GroupMembers=$(getent group $groupname | cut -d ":" -f 4)
    echo -e "\nGroupname: $groupname"
    echo "Group ID: $GroupID"
    echo "Group Members: $GroupMembers"
    echo -e "\n Which attribute would you like to modify?"
    echo -e "\n gn for Groupname"
    echo "gi for Group ID"
    echo "agm for Adding Group Members"
    echo "dgm for Delete Group Members"
    echo "exit to exit Modify Group"
    declare info
    while [[ $info != "exit" ]]; do
        echo -e "\nChoose the attribute to modify: "
        read info

        case $info in
        #Changes the groupname
        gn)
            echo "Current Groupname: $groupname"
            echo "Enter a new Groupname: "
            read newGroupname
            groupmod -n $newGroupname $groupname

            ;;
        #Changes the Group ID
        gi)
            echo "Current Group ID: $GroupID"
            echo "Enter a new Group ID: "
            read newGroupID
            groupmod -g $newGroupID $groupname
            echo "Group ID is changed to $newGroupID"
            ;;
        #Adds a Group Member
        agm)
            echo "Current Group Members: $GroupMembers"
            echo "Enter a new Group Member: "
            read newGroupMembers
            usermod -a -G $groupname $newGroupMembers
            echo "Group Members is changed to $newGroupMembers"
            ;;
        #Deletes a Group Member
        dgm)
            echo "Current Group Members: $GroupMembers"
            echo "Select a Group Member to delete: "
            read deleteGroupMembers
            gpasswd -d $deleteGroupMembers $groupname
            echo "Group Member $deleteGroupMembers is deleted!"
            ;;
        #Exits the menu
        exit)
            echo "Exiting Modification Menu"

            ;;
        #If the input is invalid
        *)
            echo "Invalid input"
            ;;
        esac
    done

}

DeleteGroup() {
    clear
    echo "Which group would you like to delete? "
    awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/group
    echo -e "Pick a group: \n"
    read groupname
    groupdel $groupname
    echo "Group $groupname is deleted!"
}

FolderAdd() {
    #Adds a folder in a specific directory and checks if the directory exists
    clear
    echo "Which directory would you like to add a folder in? "
    read directory
    ls -l $directory

    echo "Enter a name for the folder: "
    read name
    mkdir $directory/$name
    RETURN=$?
    if [[ $RETURN == 0 ]]; then
        echo "Folder named $name is created!"
    else
        echo "Folder could not be created!"
    fi

}

FolderList() {
    clear
    #View content in a folder
    echo "Which folder would you like to view? "
    read folder
    FolderDirectory=$(find / -type d -name $folder 2>/dev/null)
    FolderDirectory=$(echo "$FolderDirectory" | tr ' ' '\n')
    if [ -z "$FolderDirectory" ]; then
        echo "Folder not found"
        return
    fi
    IFS=$'\n' read -r -d '' -a array <<<"$FolderDirectory"

    for i in "${!array[@]}"; do
        printf "%3d) %s\n" "$((i + 1))" "${array[$i]}"
    done
    echo "Enter the number of the folder you would like to view: "
    read folderNumber
    FolderDirectory=${array[$folderNumber - 1]}
    echo -e "\nFolder Content: "
    #List the content of the folder in a green color
    ls -1 $FolderDirectory | awk '{print "\033[32m" $0 "\033[39m"}'

}

FolderView() {
    #Select which directory you want to view and view all properties of the folder
    clear
    echo "Which folder would you like to view? "
    read folder
    FolderDirectory=$(find / -type d -name $folder 2>/dev/null)
    FolderDirectory=$(echo "$FolderDirectory" | tr ' ' '\n')
    if [ -z "$FolderDirectory" ]; then
        echo "Folder not found"
        return
    fi
    IFS=$'\n' read -r -d '' -a array <<<"$FolderDirectory"

    for i in "${!array[@]}"; do
        printf "%3d) %s\n" "$((i + 1))" "${array[$i]}"
    done
    echo "Enter the number of the folder you would like to view: "
    read folderNumber
    FolderDirectory=${array[$folderNumber - 1]}
    #List owner of the folder
    local owner=$(ls -ld $FolderDirectory | awk '{print $3}')
    #List group of the folder
    local group=$(ls -ld $FolderDirectory | awk '{print $4}')
    #List permissions of the folder
    local permissions=$(ls -ld $FolderDirectory)
    local ownerpermissions=$(echo $permissions | cut -c 2,3,4)
    if [[ $ownerpermissions == "rwx" ]]; then
        ownerpermissions=$(echo "Owner has read, write and execute permissions")
    elif [[ $ownerpermissions == "rw-" ]]; then
        ownerpermissions=$(echo "Owner has read and write permissions")
    elif [[ $ownerpermissions == "r-x" ]]; then
        ownerpermissions=$(echo "Owner has read and execute permissions")
    elif [[ $ownerpermissions == "r--" ]]; then
        ownerpermissions=$(echo "Owner has read permissions")
    elif [[ $ownerpermissions == "-wx" ]]; then
        ownerpermissions=$(echo "Owner has write and execute permissions")
    elif [[ $ownerpermissions == "-w-" ]]; then
        ownerpermissions=$(echo "Owner has write permissions")
    elif [[ $ownerpermissions == "--x" ]]; then
        ownerpermissions=$(echo "Owner has execute permissions")
    elif [[ $ownerpermissions == "---" ]]; then
        ownerpermissions=$(echo "Owner has no permissions")
    elif [[ $ownerpermissions == "rws" ]]; then
        ownerpermissions=$(echo "Owner has read, write and execute permissions and the setuid bit is set")
    elif [[ $ownerpermissions == "rwS" ]]; then
        ownerpermissions=$(echo "Owner has read and write permissions and the setuid bit is set")
    elif [[ $ownerpermissions == "r-s" ]]; then
        ownerpermissions=$(echo "Owner has read and execute permissions and the setuid bit is set")
    elif [[ $ownerpermissions == "r-S" ]]; then
        ownerpermissions=$(echo "Owner has read permissions and the setuid bit is set")
    elif [[ $ownerpermissions == "-ws" ]]; then
        ownerpermissions=$(echo "Owner has write and execute permissions and the setuid bit is set")
    elif [[ $ownerpermissions == "-wS" ]]; then
        ownerpermissions=$(echo "Owner has write permissions and the setuid bit is set")
    elif [[ $ownerpermissions == "--s" ]]; then
        ownerpermissions=$(echo "Owner has execute permissions and the setuid bit is set")
    elif [[ $ownerpermissions == "--S" ]]; then
        ownerpermissions=$(echo "Owner has no permissions and the setuid bit is set")

    fi

    grouppermissons=$(echo $permissions | cut -c 5,6,7)
    if [[ $grouppermissons == "rwx" ]]; then
        grouppermissons=$(echo "Group has read, write and execute permissions")
    elif [[ $grouppermissons == "rw-" ]]; then
        grouppermissons=$(echo "Group has read and write permissions")
    elif [[ $grouppermissons == "r-x" ]]; then
        grouppermissons=$(echo "Group has read and execute permissions")
    elif [[ $grouppermissons == "r--" ]]; then
        grouppermissons=$(echo "Group has read permissions")
    elif [[ $grouppermissons == "-wx" ]]; then
        grouppermissons=$(echo "Group has write and execute permissions")
    elif [[ $grouppermissons == "-w-" ]]; then
        grouppermissons=$(echo "Group has write permissions")
    elif [[ $grouppermissons == "--x" ]]; then
        grouppermissons=$(echo "Group has execute permissions")
    elif [[ $grouppermissons == "---" ]]; then
        grouppermissons=$(echo "Group has no permissions")
    elif [[ $grouppermissons == "rws" ]]; then
        grouppermissons=$(echo "Group has read, write and execute permissions and the setgid bit is set")
    elif [[ $grouppermissions == "r-s" ]]; then
        grouppermissons=$(echo "Group has read and execute permissions and the setgid bit is set")
    elif [[ $grouppermissions == "r-S" ]]; then
        grouppermissons=$(echo "Group has read permissions and the setgid bit is set")
    elif [[ $grouppermissons == "rwS" ]]; then
        grouppermissons=$(echo "Group has read and write permissions and the setgid bit is set")
    elif [[ $grouppermissons == "-ws" ]]; then
        grouppermissons=$(echo "Group has write and execute permissions and the setgid bit is set")
    elif [[ $grouppermissons == "-wS" ]]; then
        grouppermissons=$(echo "Group has write permissions and the setgid bit is set")
    elif [[ $grouppermissons == "--s" ]]; then
        grouppermissons=$(echo "Group has execute permissions and the setgid bit is set")
    elif [[ $grouppermissions == "--S" ]]; then
        grouppermissons=$(echo "Group has no permissions and the setgid bit is set")
    fi
    otherpermissions=$(echo $permissions | cut -c 8,9,10)
    if [[ $otherpermissions == "rwx" ]]; then
        otherpermissions=$(echo "Others has read, write and execute permissions")
    elif [[ $otherpermissions == "rw-" ]]; then
        otherpermissions=$(echo "Others has read and write permissions")
    elif [[ $otherpermissions == "r-x" ]]; then
        otherpermissions=$(echo "Others has read and execute permissions")
    elif [[ $otherpermissions == "r--" ]]; then
        otherpermissions=$(echo "Others has read permissions")
    elif [[ $otherpermissions == "-wx" ]]; then
        otherpermissions=$(echo "Others has write and execute permissions")
    elif [[ $otherpermissions == "-w-" ]]; then
        otherpermissions=$(echo "Others has write permissions")
    elif [[ $otherpermissions == "--x" ]]; then
        otherpermissions=$(echo "Others has execute permissions")
    elif [[ $otherpermissions == "---" ]]; then
        otherpermissions=$(echo "Others has no permissions")
    elif [[ $otherpermissions == "rwt" ]]; then
        otherpermissions=$(echo "Others has read, write and execute permissions and the sticky bit is set")
    elif [[ $otherpermissions == "r-t" ]]; then
        otherpermissions=$(echo "Others has read and execute permissions and the sticky bit is set")
    elif [[ $otherpermissions == "r-T" ]]; then
        otherpermissions=$(echo "Others has read permissions and the sticky bit is set")
    elif [[ $otherpermissions == "rwT" ]]; then
        otherpermissions=$(echo "Others has read and write permissions and the sticky bit is set")
    elif [[ $otherpermissions == "-wt" ]]; then
        otherpermissions=$(echo "Others has write and execute permissions and the sticky bit is set")
    elif [[ $otherpermissions == "-wT" ]]; then
        otherpermissions=$(echo "Others has write permissions and the sticky bit is set")
    elif [[ $otherpermissions == "--t" ]]; then
        otherpermissions=$(echo "Others has execute permissions and the sticky bit is set")
    elif [[ $otherpermissions == "--T" ]]; then
        otherpermissions=$(echo "Others has no permissions and the sticky bit is set")
    fi
    #List size of the folder
    size=$(ls -ld $FolderDirectory | awk '{print $5}')
    #List when the folder was last modified
    lastmodified=$(ls -ld $FolderDirectory | awk '{print $6,$7,$8}')
    #If sticky bit is set
    stickybit=$(ls -ld $FolderDirectory | awk '{print $1}' | cut -c 10)
    if [[ $stickybit == "t" ]]; then
        stickybit=$(echo "Yes")
    elif [[ $stickybit == "T" ]]; then
        stickybit=$(echo "Yes")
    else
        stickybit=$(echo "No")
    fi

    #If setgid is set
    setgid=$(ls -ld $FolderDirectory | awk '{print $1}' | cut -c 7)
    if [[ $setgid == "s" ]]; then
        setgid=$(echo "Yes")
    elif [[ $setgid == "S" ]]; then
        setgid=$(echo "Yes")
    else
        setgid=$(echo "No")
    fi

    echo "Owner: $owner"
    echo "Group: $group"
    echo "Owner permissions: $ownerpermissions"
    echo "Group permissions: $grouppermissons"
    echo "Others permissions: $otherpermissions"
    echo "Sticky bit: $stickybit"
    echo "Setgid: $setgid"
    echo "Size: $size"
    echo "Last modified: $lastmodified"

}

FolderModify() {
    clear
    echo "Which folder would you like to view? "
    read folder
    FolderDirectory=$(find / -type d -name $folder 2>/dev/null)
    FolderDirectory=$(echo "$FolderDirectory" | tr ' ' '\n')
    if [ -z "$FolderDirectory" ]; then
        echo "Folder not found"
        return
    fi
    IFS=$'\n' read -r -d '' -a array <<<"$FolderDirectory"

    for i in "${!array[@]}"; do
        printf "%3d) %s\n" "$((i + 1))" "${array[$i]}"
    done
    echo "Enter the number of the folder you would like to view: "
    read folderNumber
    FolderDirectory=${array[$folderNumber - 1]}


    declare answer
    while [[ $answer != "exit" ]]; do
        echo "co    - Change owner"
        echo "cg    - Change group"
        echo "u     - Change permissions for owner"
        echo "g     - Change permissions for group"
        echo "a     - Change permissions for others"
        echo "sbit  - Modify sticky bit"
        echo "sgid  - Modify setgid"
        echo "exit  - Exit"
        read answer
        case $answer in
        co)
            echo "Enter the new owner: "
            read newowner
            chown $newowner $FolderDirectory
            echo "Owner has been changed"
            ;;
        cg)
            echo "Enter the new group: "
            read newgroup
            chgrp $newgroup $FolderDirectory
            echo "Group has been changed"
            ;;
        u)
            echo "Do you want to add or remove permissions? (a/r)"
            read answer
            if [[ $answer == "a" ]]; then
                echo "Do you want to add read, write or execute permissions? (r/w/x)"
                read answer
                if [[ $answer == "r" ]]; then
                    chmod +r $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "w" ]]; then
                    chmod +w $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "x" ]]; then
                    chmod +x $FolderDirectory
                    echo "Permissions have been changed"
                else
                    echo "Invalid input"
                fi
            elif [[ $answer == "r" ]]; then
                echo "Do you want to remove read, write or execute permissions? (r/w/x)"
                read answer
                if [[ $answer == "r" ]]; then
                    chmod -r $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "w" ]]; then
                    chmod -w $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "x" ]]; then
                    chmod -x $FolderDirectory
                    echo "Permissions have been changed"
                else
                    echo "Invalid input"
                fi
            else
                echo "Invalid input"
            fi
            ;;
        g)
            echo "Do you want to add or remove permissions? (a/r)"
            read answer
            if [[ $answer == "a" ]]; then
                echo "Do you want to add read, write or execute permissions? (r/w/x)"
                read answer
                if [[ $answer == "r" ]]; then
                    chmod g+r $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "w" ]]; then
                    chmod g+w $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "x" ]]; then
                    chmod g+x $FolderDirectory
                    echo "Permissions have been changed"
                else
                    echo "Invalid input"
                fi
            elif [[ $answer == "r" ]]; then
                echo "Do you want to remove read, write or execute permissions? (r/w/x)"
                read answer
                if [[ $answer == "r" ]]; then
                    chmod g-r $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "w" ]]; then
                    chmod g-w $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "x" ]]; then
                    chmod g-x $FolderDirectory
                    echo "Permissions have been changed"
                else
                    echo "Invalid input"
                fi
            else
                echo "Invalid input"
            fi
            ;;
        a)
            echo "Do you want to add or remove permissions? (a/r)"
            read answer
            if [[ $answer == "a" ]]; then
                echo "Do you want to add read, write or execute permissions? (r/w/x)"
                read answer
                if [[ $answer == "r" ]]; then
                    chmod o+r $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "w" ]]; then
                    chmod o+w $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "x" ]]; then
                    chmod o+x $FolderDirectory
                    echo "Permissions have been changed"
                else
                    echo "Invalid input"
                fi
            elif [[ $answer == "r" ]]; then
                echo "Do you want to remove read, write or execute permissions? (r/w/x)"
                read answer
                if [[ $answer == "r" ]]; then
                    chmod o-r $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "w" ]]; then
                    chmod o-w $FolderDirectory
                    echo "Permissions have been changed"
                elif [[ $answer == "x" ]]; then
                    chmod o-x $FolderDirectory
                    echo "Permissions have been changed"
                else
                    echo "Invalid input"
                fi
            else
                echo "Invalid input"
            fi
            ;;
        sbit)
            echo "Do you want to activate or deactivate Sticky bit? (a/d)"
            read answer
            if [[ $answer == "a" ]]; then
                chmod +t $FolderDirectory
                echo "Sticky bit has been activated"
            elif [[ $answer == "d" ]]; then
                chmod -t $FolderDirectory
                echo "Sticky bit has been deactivated"
            else
                echo "Invalid input"
            fi
            ;;
        sgid)
            echo "Do you want to activate or deactivate setgid? (a/d)"
            read answer
            if [[ $answer == "a" ]]; then
                chmod +s $FolderDirectory
                echo "setgid has been activated"
            elif [[ $answer == "d" ]]; then
                chmod -s $FolderDirectory
                echo "setgid has been deactivated"
            else
                echo "Invalid input"
            fi
            ;;
        exit)
            echo "Exiting..."
            ;;
        *)
            echo "Invalid input"
            ;;
        esac

    done

}

FolderDelete() {
    #If the folder is empty
    #Select the folder
    echo "Enter the folder you want to delete: "
    read folder
    FolderDirectory=$(find / -type d -name $folder -print -quit 2>/dev/null)
    if [[ -z $(ls -A $FolderDirectory) ]]; then
        echo "The folder is empty"
        echo "Do you want to delete the folder? (y/n)"
        read answer
        if [[ $answer == "y" ]]; then
            rm -r $FolderDirectory
            echo "The folder has been deleted"
        elif [[ $answer == "n" ]]; then
            echo "The folder has not been deleted"
        else
            echo "Invalid input"
        fi
    #If the folder is not empty
    else
        echo "The folder is not empty"
        echo "Do you want to delete the folder? (y/n)"
        read answer
        if [[ $answer == "y" ]]; then
            rm -r $FolderDirectory
            echo "The folder has been deleted"
        elif [[ $answer == "n" ]]; then
            echo "The folder has not been deleted"
        else
            echo "Invalid input"
        fi
    fi
}

NetworkFunction() {
    clear
    echo -e "${GREEN}Computer name${NC} = $(hostname)"
    #En for loop for att displaya alla interfaces forutom loopback
    for INTERFACES in $(ip -br addr | awk '{print $1}' | grep -v 'lo'); do

        MAC=$(cat /sys/class/net/"$INTERFACES"/address)
        IP=$(ip -br addr | grep "$INTERFACES" | awk '{print $3}' | cut -d '/' -f 1)
        GATE=$(ip -4 route show default | grep "$INTERFACES" | cut -d ' ' -f 3 | tail -)
        STATUS=$(cat /sys/class/net/"$INTERFACES"/operstate)

        #Flaggan (-z) testar om string = 0, om string = 0 sa ar det TRUE. dvs if far arbeta
        if [[ -z "$IP" ]]; then
            IP="NONE"
        fi

        if [[ -z "$GATE" ]]; then
            GATE="NONE"
        fi

        echo -e "\n${GREEN}IP${NC} = $IP"
        echo -e "\n${GREEN}MAC${NC} = $MAC"
        echo -e "\n${GREEN}GATE${NC} = $GATE"
        echo -e "\n${GREEN}STATUS${NC} = $STATUS"

    done

}

BackToMenu() {
    echo -e "\nPress ${RED}ENTER${NC} to enter menu"
    read x
}

MenuFunction

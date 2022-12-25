
#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

MenuFunction(){

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


}

AddUserFunction(){
    clear
    echo "Pick a Username: "
    read username
    useradd -m $username
    echo "Pick a Password: "
    passwd $username
}

ListUserFunction=$(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd) 


ListUserAttributes(){   
    clear 
    echo "Which user would you like to view? "
    awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd
    echo -e "Pick a user: \n"
    read username
    UserID=$(getent passwd $username | cut -d ":" -f 3)
    GroupID=$(getent passwd $username | cut -d ":" -f 4)
    HomeDirectory=$(getent passwd $username| cut -d ":" -f 6)
    ShellDirectory=$(getent passwd $username| cut -d ":" -f 7)
    #Fint du gor! <3 /Mika

    echo -e "\nUsername: $username"
    echo "User ID: $UserID"
    echo "Group ID: $GroupID"
    echo "Home Directory: $HomeDirectory"
    echo "Shell: $ShellDirectory"
    



}

ModifyUserFunction(){
    clear 
    echo "Which user would you like to modify? "
    awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd
    echo -e "Pick a user: \n"
    read username
    UserID=$(getent passwd $username | cut -d ":" -f 3)
    GroupID=$(getent passwd $username | cut -d ":" -f 4)
    HomeDirectory=$(getent passwd $username| cut -d ":" -f 6)
    ShellDirectory=$(getent passwd $username| cut -d ":" -f 7)
    #Fint du gor! <3 /Mika

    echo -e "\nUsername: $username"
    echo "Password: *******"
    echo "User ID: $UserID"
    echo "Group ID: $GroupID"
    echo "Home Directory: $HomeDirectory"
    echo "Shell: $ShellDirectory"
    echo -e "\n Which attribute would you like to modify?"
    echo -e "\n -u for Username"
    echo "-ui for User ID"
    echo "-gi for Group ID"
    echo "-hd for Home Directory"
    echo "-sd for Shell Directory"
    echo -e "\nChoose the attribute to modify: "

while [ "$info" != "exit"] ; do
    read info

    case $info in
    
    -u)
    echo "Current Username: $username"
    echo "Enter a new Username: "
    read newUsername
    usermod -l $newUsername $username
    
    ;;

    -ui)
    echo "Current User ID: $UserID"
    echo "Enter a new User ID: "
    read newUserID
    usermod -u $newUserID $username
    ;;
    -gi)
    echo "Current Group ID: $GroupID"
    echo "Enter a new Group ID: "
    read newGroupID
    usermod -g $newGroupID $username
    ;;
    -hd)
    echo "Current Home Directory: $HomeDirectory"
    echo "Enter a new Home Directory: "
    read newHomeDirectory
    usermod -d $newHomeDirectory $username
    ;;
    -sd)
    echo "Current Shell Directory: $ShellDirectory"
    echo "Enter a new Shell Directory: "
    read newShellDirectory
    usermod -s $newShellDirectory $username
    ;;

    exit)
    echo "Exiting Modification Menu"
    exit
    ;;
    *)
    echo "Invalid input"
    ;; 
    esac
done    
















}


DeleteUser(){

}

AddGroup(){

}

ListGroup(){

}

ViewGroup(){

}

ModifyGroup(){

}

DeleteGroup(){

}

FolderAdd(){

RETURN=$?
if [[ $RETURN == 0 ]]; then
    echo "Enter a name for the folder: "
    read name
    mkdir $name
    RETURN=$?
    if [[ $RETURN == 0 ]];; then
        echo "Folder named $name is created!"
    elif
        echo "Folder could not be created!"
    fi
fi


}

FolderList(){

}
FolderView(){

}
FolderModify(){
    
}
FolderDelete(){
 
}

NetworkFunction(){
echo "Computer name: $hostname"
#En for loop for att displaya alla interfaces forutom loopback
for INTERFACES in $(ip -br addr | awk '{print $1}' | grep -v 'lo'); do

MAC=$(cat /sys/class/net/"$INTERFACES"/address)
IP=$(ip -br addr | grep "$INTERFACES" | awk '{print $3}' | cut -d '/' -f 1)
GATE=$(ip -4 route show default | grep "$INTERFACES" | cut -d ' ' -f 3 | tail -
STATUS=$(cat /sys/class/net/"$INTERFACES"/operstate)

#echo "IP address: $(ip route get 1.2.3.4 | awk '{print $7}')"
#echo "MAC address: $(ip -o link show | cut -d ' ' -f2,20 | grep -v 'lo' | cut ->
#echo "INTERFACE: $(ip -br addr | awk '{print $1}' | grep -v 'lo')"
if [[ -z "$IP" ]]; then
    IP="NONE"
fi

if [[ -z "$GATE" ]]; then
    GATE="NONE"
fi


echo "IP = $IP"
echo "MAC = $MAC"
echo "GATE = $GATE"
echo "STATUS = $STATUS"

done

}






#Maste satta x till nagot annars far den damp i loopen.
x="1"
until [ $x == "ex" ]
do
read x
case $x in

ni)
#FUNKTION
;;

au)
#FUNKTION
;;

lu)
#FUNKTION
;;

vu)
#FUNKTION
;;

mu)
#FUNKTION
;;

du)
#FUNKTION
;;

ag)
#FUNKTION
;;

lg)
#FUNKTION
;;

vg)
#FUNKTION
;;

mg)
#FUNKTION
;;

dg)
#FUNKTION
;;

af)
#FUNKTION
;;

lf)
#FUNKTION
;;

vf)
#FUNKTION
;;

mf)
#FUNKTION
;;

df)
#FUNKTION
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
;;

esac

done

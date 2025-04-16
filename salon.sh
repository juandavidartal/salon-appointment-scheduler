#!/bin/bash

echo "test"

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# Display services 
MAIN_MENU() {
  while true
  do
    if [[ $1 ]]
    then
      echo -e "\n$1"
    fi

    echo "How I may help you?"
    echo -e "\n1) Haircut and Trims\n2) Hair Coloring\n3) Manicure and Pedicure\n4) Exit\n"

    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in
      1) ADD_APPOINTMENT ;;
      2) ADD_APPOINTMENT ;;
      3) ADD_APPOINTMENT ;;
      4) exit 0 ;;
      *) echo -e "\nPlease, enter a valid option (1-4)." ;;
    esac
  done
}


ADD_APPOINTMENT(){

# Ask for phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE


CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")


# If phone number isn't registered, register user name
if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME
  INSERT_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$(echo "$CUSTOMER_NAME" | sed -E 's/^ *| *$//g')
  
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
CUSTOMER_ID=$(echo "$CUSTOMER_ID" | sed -E 's/^ *| *$//g')

echo -e "\nWhat time do you want your appointment to be?"
read SERVICE_TIME

#Create appointment with service_id, phone, name and time
APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')") 


# Sucessfull Message
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
# Service formated output
SERVICE=$(echo $SERVICE | sed -E 's/^ *| *$//g')
echo -e "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
exit 0
}

MAIN_MENU















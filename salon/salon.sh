#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU(){
   if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
SERVICES_RESULT=$($PSQL "SELECT * FROM services ORDER BY service_id")
echo "$SERVICES_RESULT" | while read ID BAR SERVICE
do
echo "$ID) $SERVICE"
done
read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[ -z $SERVICE_NAME ]]
then
MAIN_MENU "I could not find that service. What would you like today?"
else
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
INSERT_CUSTOMER_RESULT==$($PSQL " INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME') ")
fi
SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed -E 's/^ *//')
NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -E 's/^ *//')

echo -e "What time would you like your $SERVICE_NAME_FORMATTED, $NAME_FORMATTED?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $NAME_FORMATTED."
fi
}

MAIN_MENU
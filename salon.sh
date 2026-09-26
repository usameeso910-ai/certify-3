#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

MAIN_MENU() {
  echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
}

MAIN_MENU

echo -e "\nWhat service would you like today?"
read SERVICE_ID_SELECTED

while [[ ! $($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED") ]]; do
  MAIN_MENU
  echo -e "\nI could not find that service. What would you like today?"
  read SERVICE_ID_SELECTED
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_ID ]]; then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  $PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
fi

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

echo -e "\nWhat time would you like your $SERVICE_NAME?"
read SERVICE_TIME

$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

#!/bin/bash

# Define an array of username-password pairs
usernames=(
  "jsmith:XyZ12345"
  "krodriguez:P@ssw0rd123"
  "amiller:9876Abcd"
  "lharris:qwerty2023"
  "glee:Purple21!"
  "jrivera:LinuxRocks22"
  "bward:SecretPass789"
  "cjohnson:MyP@55word"
  "bbailey:Sunshine98"
  "bmartin:1LoveLinux"
  "mgonzalez:Welcome@23"
  "jcampbell:p@$$w0rd"
  "jcooper:NewUser#2023"
  "rlee:Spring2023!"
  "ndavis:SecurePa$$w0rd"
  "wrogers:LinuxIsAwesome"
  "mturner:1234abcd!"
  "kmurphy:Passw0rd!23"
  "hcollins:Linux12345"
  "dcook:Pa$$w0rd2023"
)

# Iterate over the array and create users with assigned passwords
for login in "${usernames[@]}"; do
  username=$(echo "$login" | cut -d':' -f1)
  password=$(echo "$login" | cut -d':' -f2)
  
  # Create user account
  sudo useradd -m "$username"
  
  # Set user password
  echo "$username:$password" | sudo chpasswd
  
  echo "User account created:"
  echo "Username: $username"
  echo "Password: $password"
  echo "------------------"
done

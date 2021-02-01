#!/bin/bash

SUBSCRIPTION="7606e7fa-b41a-4a29-99e1-01acac65a553"

#GETKEYVAULTLIST

function kvlist () {
    az keyvault list --subscription ${SUBSCRIPTION} --resource-group "${rglist}" | jq '.[].name'

}

echo $(kvlist)

i=1

function createsecret () {
    local vname=$(echo $(kvlist) | tr -d '"')
    local sname="testsecret"
    local nsname="$(echo $sname$i)"


    az keyvault secret set \
      --name ${nsname} \
      --value "@sometestsecretstuff" \
      --subscription ${SUBSCRIPTION} \
      --vault-name ${vname}

    echo $nsname
}

#echo $(createsecret)

until [[ $i -gt 10 ]]; do
  createsecret
  echo $i
  ((i++))
done
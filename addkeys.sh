#!/bin/bash

SUBSCRIPTION="7606e7fa-b41a-4a29-99e1-01acac65a553"

#GETKEYVAULTLIST

function kvlist () {
    az keyvault list --subscription ${SUBSCRIPTION} --resource-group "${rglist}" | jq '.[].name'

}

echo $(kvlist)

i=1

function createkey () {
    local vname=$(echo $(kvlist) | tr -d '"')
    local kname="testkey"
    local nkname="$(echo $kname$i)"


    az keyvault key create \
      --name ${nkname} \
      --subscription ${SUBSCRIPTION} \
      --vault-name ${vname}

    echo $nkname
}

#echo $(createkey)

until [[ $i -gt 10 ]]; do
  createkey
  echo $i
  ((i++))
done
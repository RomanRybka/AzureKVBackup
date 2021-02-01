#!/bin/bash

SUBSCRIPTION="7606e7fa-b41a-4a29-99e1-01acac65a553"

#GETRGTLIST

function rglist () {
    az group list --subscription ${SUBSCRIPTION} | jq '.[].name'

}

echo $(rglist)

#GETKEYVAULTLIST

function kvlist () {
    az keyvault list --subscription ${SUBSCRIPTION} --resource-group "${rglist}" | jq '.[].name'

}

echo $(kvlist)

#KEYS

function listkeys () {
    local name
    local list

    name=$(echo $(kvlist) | tr -d '"')
    list=$(az keyvault key list --vault-name ${name} | jq '.[].name')
    echo $list
}

echo $(listkeys)



function backupkey () {
    local name=$(echo $1 | tr -d '"')
    local list=$(echo $2 | tr -d '"')
    local dir=$3
    local file="$dir/${name}_${list}.keybackup"


    az keyvault key backup \
      --file ${file} \
      --name ${list}\
      --subscription ${SUBSCRIPTION} \
      --vault-name ${name}
}
vndir=$(echo $(kvlist) | tr -d '"')
kdir="./keys/${vndir}"
mkdir -p $kdir
chmod 777 $kdir

for name in $(kvlist); do
    for list in $(listkeys $name); do
        echo "Backup key ${list} in ${name}"
        backupkey $name $list $kdir
    done
done

#SECRETS

function listsecrets () {
    local name
    local secret

    name=$(echo $(kvlist) |tr -d '"')
    secret=$(az keyvault secret list --vault-name ${name} | jq '.[].name')

    echo $secret
}

echo $(listsecrets)


function backupsecret () {
    local name=$(echo $1 | tr -d '"')
    local secret=$(echo $2 | tr -d '"')
    local dir=$3
    local file="$dir/${name}_${secret}.secretbackup"


    az keyvault secret backup \
      --file ${file} \
      --name ${secret}\
      --subscription ${SUBSCRIPTION} \
      --vault-name ${name}
}


sdir="./secrets/${vndir}"
mkdir -p $sdir
chmod 777 $sdir

for name in $(kvlist); do
    for secret in $(listsecrets $name); do
        echo "Backup secret ${secret} in ${name}"
        backupsecret $name $secret $sdir
    done
done

#CERTIFICATES

function listcerts () {
    local name
    local cert

    name=$(echo $(kvlist) |tr -d '"')
    cert=$(az keyvault certificate list --vault-name ${name} | jq '.[].name')

    echo $cert
}

echo $(listcerts)


function backupcert () {
    local name=$(echo $1 | tr -d '"')
    local cert=$(echo $2 | tr -d '"')
    local dir=$3
    local file="$dir/${name}_${cert}.certbackup"


    az keyvault certificate backup \
      --file ${file} \
      --name ${cert}\
      --subscription ${SUBSCRIPTION} \
      --vault-name ${name}
}

cdir="./certificates/${vndir}"
mkdir -p $cdir
chmod 777 $cdir

for name in $(kvlist); do
    for cert in $(listcerts $name); do
        echo "Backup certificate ${cert} in ${name}"
        backupcert $name $cert $cdir
    done
done









#!/bin/bash

SUBSCRIPTION="7606e7fa-b41a-4a29-99e1-01acac65a553"

#GETKEYVAULTLIST

function kvlist () {
    az keyvault list --subscription ${SUBSCRIPTION} | jq '.[].name'

}

echo $(kvlist)

vndir=$(echo $(kvlist) | tr -d '"')
kdir="./keys/${vndir}"
sdir="./secrets/${vndir}"

#GETKEYLIST

function listkeys () {
    local klist
    local vname

    klist=$(ls $kdir)
    vname=$(echo $(kvlist) |tr -d '"')
    echo $klist
}

echo $(listkeys)


function restorekey () {
    local name=$(echo $1 |tr -d '"')
    local dir=$3
    local file="$dir/${name}"
    local vname=$(echo $2 |tr -d '"')

    az keyvault key restore \
      --file ${file} \
      --subscription ${SUBSCRIPTION} \
      --vault-name ${vname}
}

#restorekey $name $kdir

for vname in $(kvlist); do
    for klist in $(listkeys $vname); do
        echo "Restore key ${klist} in ${vname}..."
        restorekey $klist $vname $kdir
    done
done

#RESTORESECRETS
function listsecrets () {
    local slist
    local vname

    slist=$(ls $sdir)
    vname=$(echo $(kvlist) |tr -d '"')
    echo $slist
}

echo $(listsecrets)


function restoresecret () {
    local name=$(echo $1 | tr -d '"')
    local dir=$3
    local file="$dir/${name}"
    local vname=$(echo $2 |tr -d '"')


    az keyvault secret restore \
      --file ${file} \
      --subscription ${SUBSCRIPTION} \
      --vault-name ${vname}
}

for vname in $(kvlist); do
    for slist in $(listsecrets $vname); do
        echo "Restore secret ${slist} in ${vname}..."
        restoresecret $slist $vname $sdir
    done
done
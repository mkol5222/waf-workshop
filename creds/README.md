# Credentials - tools to get Azure service principals for automation

* Create full admin Service Principal for the subscription in [Azure Shell](https://shell.azure.com/)

<details>
<summary>Service Principal creation script (click to expand)</summary>

```bash
ENVID=$(openssl rand -hex 4 | tee /tmp/automagic-envid.txt)
SUBSCRIPTION=$(az account show --query id --output tsv)

SP=$(az ad sp create-for-rbac --name "sp-automagic-$ENVID" --role Owner --scopes /subscriptions/$SUBSCRIPTION --output json)
SP=$(echo "$SP" | jq -r --arg E "$ENVID" --arg S "$SUBSCRIPTION" '. | .envId = $E | .subscriptionId = $S')

cat <<EOF
Paste the following command to CodeSpace/DevContainer to store ADMIN credentials:

echo $(echo $SP | jq -c . | base64 -w0) | base64 -d | jq . | tee secrets/sp.json

EOF

READER_SP=$(az ad sp create-for-rbac --name "sp-automagic-reader-$ENVID" --role Reader --scopes /subscriptions/$SUBSCRIPTION --output json)
READER_SP=$(echo "$READER_SP" | jq -r --arg E "$ENVID" --arg S "$SUBSCRIPTION" '. | .envId = $E | .subscriptionId = $S')

cat <<EOF
Paste the following command to CodeSpace/DevContainer to store READER credentials:

echo $(echo $READER_SP | jq -c . | base64 -w0) | base64 -d | jq . | tee secrets/reader.json

EOF
```
</details>

* You can also run following command in [Azure Shell](https://shell.azure.com/)
```bash
bash <(curl -L https://run.klaud.online/labsp.sh)
```

* Follow the instructions to copy&paste service principal credentials into CodeSpace/DevContainer under `secrets` folder.

```bash
# folder for secrets has to exist under /workspaces/automagic-septemper-2025
mkdir -p secrets

# follow instructions to bring sp.json and reader.json

# test credentials with simple scripts
make reader-test

# login as Azure admin
make sp-login

# congrats
```

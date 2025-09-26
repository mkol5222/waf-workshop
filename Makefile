sp-login:
	./scripts/sp-login.sh
reader-test:
	./scripts/reader-test.sh
vmss-up:
	(cd azure-vmss && ./up.sh)
vmss-down:
	(cd azure-vmss && ./down.sh)
vmss-ssh:
	(cd azure-vmss && ./ssh.sh)
vmss: vmss-up

kv-up:
	(cd azure-vmss/keyvault && ./up.sh)
kv-down:
	(cd azure-vmss/keyvault && ./down.sh)
kv: kv-up

sp-loginx:
	dotenvx run -- ./scripts/sp-loginx.sh

waf-ssh:
	(cd azure-vmss && ./ssh.sh)
waf-ssh1:
	(cd azure-vmss && ./ssh.sh 1)
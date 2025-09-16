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
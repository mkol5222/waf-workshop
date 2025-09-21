#!/bin/bash


npx @dotenvx/dotenvx run -f ../../.env -fk ../../.env.keys -- terraform destroy -auto-approve

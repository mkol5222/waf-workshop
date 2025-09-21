#!/bin/bash

npx @dotenvx/dotenvx run -f ../../.env -fk ../../.env.keys -- terraform init
npx @dotenvx/dotenvx run -f ../../.env -fk ../../.env.keys -- terraform apply -auto-approve

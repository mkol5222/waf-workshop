#!/bin/bash


dotenvx run -f ../../.env -fk ../../.env.keys -- terraform destroy -auto-approve

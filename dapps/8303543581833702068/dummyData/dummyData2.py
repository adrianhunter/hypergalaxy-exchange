#!/usr/bin/env python

import requests
import time
import random

temperature = 0
power = 0
gas = 0
day = 0
i = 0

dapp_api_url = "http://127.0.0.1:4000/api/dapps/15716992573004612950/api"
device_id = "16313739661670634666L"

while True:
	temperature = random.randint(16,24)
	power = random.randint(95,105)
	gas = random.randint(1,160)
	i = i + 1 #Counter
	day = str(i) #Convert int into string
	if i <= 9:
		day = '0'+day

	payload = {'secret': '1234','deviceId': device_id, 'deviceName': 'Lisk RaspberryPi', 'temperature': temperature, 'power': power, 'gas': gas, 'clock': day+'-03-2016'}
	r = requests.put(dapp_api_url + "/put/values", data=payload)
	print(r.content)
	print(payload)

	time.sleep(10)
	if i == 30:
		break
print("END")

#!/usr/bin/env python

import requests
import time
import random

temperature = 0
power = 0
gas = 0
day = 0
i = 0

dapp_api_url = "http://127.0.0.1:4000/api/dapps/8303543581833702068/api"
device_id = "13933155277692406562L"

while True:
	temperature = random.randint(16,24)
	power = random.randint(95,105)
	gas = random.randint(1,160)
	i = i + 1 #Counter
	day = str(i) #Convert int into string
	if i <= 9:
		day = '0'+day

	payload = {'secret': 'obey east curtain shallow erase refuse feature lake cereal lesson road glad','deviceId': device_id, 'deviceName': 'Lisk C.H.I.P.', 'temperature': temperature, 'power': power, 'gas': gas, 'clock': day+'-03-2016'}
	r = requests.put(dapp_api_url + "/put/values", data=payload)
	print(r.content)
	print(payload)

	time.sleep(10)
	if i == 30:
		break
print("END")
